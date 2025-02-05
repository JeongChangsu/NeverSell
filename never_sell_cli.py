import os
import time
import argparse

from binance.enums import *
from binance.client import Client


def parse_interval(interval_str: str) -> int:
    """
    '1d', '1h', '30m' 등의 문자열을 초 단위로 변환하는 간단한 함수.
    - 예: '1d' -> 86400초, '1h' -> 3600초
    - 알 수 없는 형식이면 기본 24시간(86400초)로 처리.
    """
    interval_str = interval_str.lower().strip()

    if interval_str.endswith("d"):
        # '1d' -> 일(day) 단위
        days = int(interval_str.replace("d", ""))
        return days * 24 * 3600
    elif interval_str.endswith("h"):
        # '1h' -> 시간(hour) 단위
        hours = int(interval_str.replace("h", ""))
        return hours * 3600
    elif interval_str.endswith("m"):
        # '30m' -> 분(minute) 단위
        mins = int(interval_str.replace("m", ""))
        return mins * 60
    else:
        # 위 케이스가 아니면, 기본 1일(86400초)로 간주
        return 24 * 3600


def buy_crypto(client: Client, symbol: str, usdt_amount: float):
    """
    주어진 USDT 금액만큼 지정된 심볼(BTCUSDT 등)을 시장가로 매수.
    - symbol: 예) 'BTCUSDT'
    - usdt_amount: 매수에 사용할 달러(USDT) 금액
    """

    # 현재 시세 가져오기
    try:
        ticker = client.get_symbol_ticker(symbol=symbol)
        current_price = float(ticker["price"])
    except Exception as e:
        print(f"[에러] 시세 조회 실패: {e}")
        return

    # 실제 매수할 코인 수량 계산 (금액 / 시세)
    quantity = usdt_amount / current_price

    # 거래소마다 허용 소수점 자릿수가 다를 수 있으므로, 예시로 소수점 6자리까지만 반올림
    # (실제 환경에서는 각 심볼별 최소 주문 수량/단위 등을 확인해야 함)
    quantity = round(quantity, 6)

    # 매수 주문 실행
    try:
        client.create_order(
            symbol=symbol,
            side=SIDE_BUY,
            type=ORDER_TYPE_MARKET,
            quantity=quantity
        )
        print(f"[매수 성공] {symbol} / 수량: {quantity}, 대략 가격: {current_price} USDT")
        # 주문 응답(order)에 주문 ID 등 상세 정보가 담겨 있으므로 필요시 출력/로깅 가능
    except Exception as e:
        print(f"[에러] 매수 주문 실패: {e}")


def main():
    parser = argparse.ArgumentParser(description="NeverSell CLI - 간단 DCA 매수 테스트")
    parser.add_argument("--symbol", default="BTCUSDT",
                        help="매수할 심볼 (default: BTCUSDT)")
    parser.add_argument("--amount", type=float, required=True,
                        help="매수에 사용할 USDT 금액 (정수 또는 실수)")
    parser.add_argument("--interval", default="1d",
                        help="매수 주기. 예: 1d(1일), 12h(12시간), 30m(30분) 등 (기본: 1d)")
    parser.add_argument("--repeat", action="store_true",
                        help="이 옵션을 주면, 지정한 interval 마다 무한 반복 매수")
    args = parser.parse_args()

    # 환경변수에서 API 키를 가져옴
    api_key = os.getenv("BINANCE_API_KEY")
    api_secret = os.getenv("BINANCE_API_SECRET")

    if not api_key or not api_secret:
        print("환경변수 BINANCE_API_KEY 혹은 BINANCE_API_SECRET가 설정되지 않았습니다.")
        print("예: export BINANCE_API_KEY='...' / export BINANCE_API_SECRET='...'")
        return

    # Binance Client 초기화
    client = Client(api_key, api_secret)

    # CLI 인자로 받은 interval을 초 단위로 변환
    interval_seconds = parse_interval(args.interval)

    if args.repeat:
        # 무한 반복 매수
        print(f"반복 매수 모드 활성화: {args.interval}마다 {args.amount} USDT 어치 {args.symbol} 매수")
        while True:
            buy_crypto(client, args.symbol, args.amount)
            print(f"{interval_seconds}초 후 다음 매수를 진행합니다...\n")
            time.sleep(interval_seconds)
    else:
        # 1회 매수
        print(f"1회 매수 실행: {args.amount} USDT 어치 {args.symbol} 매수")
        buy_crypto(client, args.symbol, args.amount)


if __name__ == "__main__":
    main()
