import os
import time
import math
import argparse

from binance.enums import *
from binance.client import Client


def parse_interval(interval_str: str) -> int:
    """
    '1d', '1h', '30m' 등의 문자열을 초 단위로 변환하는 함수.
    예: '1d' -> 86400초, '1h' -> 3600초
    """
    interval_str = interval_str.lower().strip()
    if interval_str.endswith("d"):
        days = int(interval_str.replace("d", ""))
        return days * 24 * 3600
    elif interval_str.endswith("h"):
        hours = int(interval_str.replace("h", ""))
        return hours * 3600
    elif interval_str.endswith("m"):
        mins = int(interval_str.replace("m", ""))
        return mins * 60
    else:
        return 24 * 3600


def get_lot_size_info(client: Client, symbol: str) -> dict:
    """
    심볼의 LOT_SIZE 필터 정보를 반환함.
    반환값: {"minQty": float, "stepSize": float}
    """
    info = client.get_symbol_info(symbol)
    lot_filter = next((f for f in info["filters"] if f["filterType"] == "LOT_SIZE"), None)
    if lot_filter:
        return {
            "minQty": float(lot_filter["minQty"]),
            "stepSize": float(lot_filter["stepSize"])
        }
    else:
        return {"minQty": 0.0, "stepSize": 0.0}


def adjust_to_step_size(quantity: float, step_size: float) -> float:
    """
    주문 수량(quantity)을 주어진 step_size의 배수로 내림하여 조정.
    예를 들어, step_size가 0.00001000이면 quantity를 해당 단위에 맞게 내림 처리.
    """
    adjusted = math.floor(quantity / step_size) * step_size
    decimals = len(str(step_size).split('.')[-1].rstrip('0'))
    return round(adjusted, decimals)


def convert_crypto(client: Client, from_asset: str, to_asset: str, from_amount: float):
    """
    Binance의 convert API를 사용하여 from_asset을 to_asset으로 변환하는 함수.
    이 기능은 주문량이 최소 주문 수량에 미달할 경우 사용.
    """
    payload = {
        "fromAsset": from_asset,
        "toAsset": to_asset,
        "fromAmount": str(from_amount),
        "timestamp": int(time.time() * 1000)
    }
    try:
        response = client._request_api('sapi', 'POST', '/sapi/v1/convert/trade', payload)
        print(f"[컨버트 성공] {from_amount} {from_asset} -> {to_asset} 변환 완료, 응답: {response}")
    except Exception as e:
        print(f"[에러] 컨버트 주문 실패: {e}")


def buy_crypto(client: Client, symbol: str, usdt_amount: float):
    """
    지정된 USDT 금액으로 심볼(BTCUSDT 등)을 매수하는 함수.
    주문 수량을 step size에 맞게 조정하고, 최소 주문 수량 미달 시 convert 기능 사용.
    거래 성공 후, 남은 테더, 차감된 테더 수량, 추가된 비트코인 수량을 로그로 출력.
    """
    # USDT 잔고 조회
    try:
        balance_info = client.get_asset_balance(asset="USDT")
        usdt_balance = float(balance_info["free"])
        print(f"[잔고] 현재 USDT 잔고: {usdt_balance:.9f}")
    except Exception as e:
        print(f"[에러] USDT 잔고 조회 실패: {e}")
        return

    if usdt_balance < usdt_amount:
        print(f"[경고] 주문에 필요한 금액({usdt_amount} USDT)이 잔고({usdt_balance:.9f} USDT)보다 많습니다.")
        return

    # 현재 시세 조회
    try:
        ticker = client.get_symbol_ticker(symbol=symbol)
        current_price = float(ticker["price"])
    except Exception as e:
        print(f"[에러] 시세 조회 실패: {e}")
        return

    # USDT 금액으로 구매 가능한 원래 수량 계산
    raw_quantity = usdt_amount / current_price

    # LOT_SIZE 필터 정보 확인
    lot_info = get_lot_size_info(client, symbol)
    min_qty = lot_info["minQty"]
    step_size = lot_info["stepSize"]

    # step size에 맞게 수량 조정
    quantity = adjust_to_step_size(raw_quantity, step_size)
    print(f"[정보] 계산된 원래 수량: {raw_quantity:.9f}, step size 적용 후 수량: {quantity:.9f}, 최소 주문 수량: {min_qty:.9f}")

    # 만약 보정된 주문 수량이 최소 주문 수량보다 낮으면 convert 기능 사용
    if quantity < min_qty:
        print(f"[정보] 보정된 주문 수량({quantity:.9f})이 최소 주문 수량({min_qty:.9f})보다 낮습니다.")
        print("[정보] Convert 기능을 사용하여 USDT를 BTC로 변환합니다.")
        convert_crypto(client, from_asset="USDT", to_asset="BTC", from_amount=usdt_amount)
    else:
        try:
            order = client.create_order(
                symbol=symbol,
                side=SIDE_BUY,
                type=ORDER_TYPE_MARKET,
                quantity=quantity
            )
            # 주문 응답에서 거래 정보 추출
            executed_qty = float(order.get("executedQty", 0))
            cummulative_quote_qty = float(order.get("cummulativeQuoteQty", 0))
            print(f"[매수 성공] {symbol} / 주문 수량: {quantity:.9f}, 대략 가격: {current_price:.2f} USDT")
            print(f"거래 상세: 차감된 테더: {cummulative_quote_qty:.9f} USDT, 추가된 비트코인: {executed_qty:.9f} BTC")
            # 거래 후 잔액 조회
            usdt_after = client.get_asset_balance(asset="USDT")
            btc_after = client.get_asset_balance(asset="BTC")
            print(f"거래 후 잔액: 남은 테더: {float(usdt_after['free']):.9f} USDT, 보유 비트코인: {float(btc_after['free']):.9f} BTC")
        except Exception as e:
            print(f"[에러] 매수 주문 실패: {e}")


def main():
    parser = argparse.ArgumentParser(description="NeverSell CLI - 간단 DCA 매수 테스트")
    parser.add_argument("--symbol", default="BTCUSDT",
                        help="매수할 심볼 (기본: BTCUSDT)")
    parser.add_argument("--amount", type=float, required=True,
                        help="매수에 사용할 USDT 금액")
    parser.add_argument("--interval", default="1d",
                        help="매수 주기. 예: 1d(1일), 12h(12시간), 30m(30분) (기본: 1d)")
    parser.add_argument("--repeat", action="store_true",
                        help="이 옵션을 주면, 지정한 interval마다 무한 반복 매수")
    args = parser.parse_args()

    # 환경변수에서 API 키 로드
    api_key = os.getenv("BINANCE_API_KEY")
    api_secret = os.getenv("BINANCE_API_SECRET")
    if not api_key or not api_secret:
        print("환경변수 BINANCE_API_KEY 혹은 BINANCE_API_SECRET가 설정되지 않았습니다.")
        print("예: export BINANCE_API_KEY='...' / export BINANCE_API_SECRET='...'")
        return

    # Binance Client 초기화
    client = Client(api_key, api_secret)
    interval_seconds = parse_interval(args.interval)

    if args.repeat:
        print(f"반복 매수 모드: {args.interval}마다 {args.amount} USDT 어치 {args.symbol} 매수")
        while True:
            print("--------------------------------------------------")
            print("주문 전 USDT 잔고 및 주문 시도:")
            buy_crypto(client, args.symbol, args.amount)
            print(f"{interval_seconds}초 후 다음 매수를 진행합니다...\n")
            time.sleep(interval_seconds)
    else:
        print(f"1회 매수 실행: {args.amount} USDT 어치 {args.symbol} 매수")
        buy_crypto(client, args.symbol, args.amount)


if __name__ == "__main__":
    main()
