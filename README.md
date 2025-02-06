
---

[Click here for Korean version 🇰🇷](./README_ko.md)

---

# NeverSell

*NeverSell is an open-source application that automates recurring Bitcoin purchases (DCA – Dollar Cost Averaging) on crypto exchanges. It aims to help users steadily accumulate cryptocurrency without emotion-driven trading, essentially encouraging a "never sell" long-term mindset.*

---

## Project Introduction

**NeverSell** enables users to connect to a crypto exchange (initially Binance) via API keys and schedule automatic periodic purchases of Bitcoin. The project started as a simple Command Line Interface (CLI) tool to test core functionality, and will now evolve into a full-fledged mobile app. The long-term vision includes support for multiple exchanges and wallets, more advanced DCA strategies (like buying extra on dips), and a subscription model for premium features. By automating crypto dollar-cost averaging, NeverSell helps investors avoid trying to time the market and instead consistently build their portfolio over time.

**Key Goals:**

- **Automate DCA Purchases:** Allow users to set up recurring buy orders on a schedule (e.g., daily/weekly Bitcoin buys) through exchange APIs, starting with Binance.  
- **Mobile App Accessibility:** Provide an easy-to-use mobile application so users can monitor and adjust their DCA settings on the go.  
- **Advanced Strategies:** Implement optional features such as a “buy the dip” option that executes extra purchases when prices drop significantly, as well as other strategy tweaks based on market conditions.  
- **Multi-Exchange Support:** Extend support to popular exchanges like Coinbase, Kraken, Bitfinex, etc., and possibly integrate with crypto wallets, so users can aggregate their DCA strategy across platforms.  
- **Subscription Model:** Eventually offer premium features through a subscription (e.g. advanced strategy customization, priority support), with secure payment integration for sustainability.  
- **Community-Driven & Open Source:** Develop the project in the open, encouraging community contributions, feedback, and transparency. All core features will be free and open-source, with an option for users to support development via a subscription for added services.

---

## Tech Stack & Development

After evaluating various options, we have **finalized** the following core technologies for Phase 2 and beyond:

- **Mobile Application:** **Flutter (Dart)**  
  - Flutter offers near-native performance on both iOS and Android, a growing ecosystem, and a highly consistent UI framework.

- **Backend Services:** **Python FastAPI**  
  - FastAPI is known for its fast performance, intuitive syntax (Pydantic data models), automatic Swagger docs, and asynchronous support.  
  - We plan to use PostgreSQL as the primary database.

- **Containerization & Deployment:** **Docker**  
  - Containerizing the FastAPI backend and the PostgreSQL DB allows for a consistent environment across development, staging, and production.  
  - Docker Compose will help manage multi-container setups.

- **CLI Prototype (Phase 1)**  
  - Python CLI using libraries such as `python-binance` for initial DCA logic (already completed).

---

## Installation & Usage (CLI Prototype)

> **Note**: The CLI prototype corresponds to **Phase 1**. For instructions on the **Flutter** mobile app and **FastAPI** backend, please see the Phase 2 roadmap and future updates.

1. **Prerequisites:**  
   - Python 3.x installed  
   - A Binance account with API keys (trading permission enabled, withdrawal disabled)

2. **Installation:**  
   ```bash
   git clone https://github.com/JeongChangsu/never-sell.git
   cd never-sell
   pip install -r requirements.txt
   ```

3. **Configuration:**  
   - Set `BINANCE_API_KEY` and `BINANCE_API_SECRET` in environment variables,  
   **or** store them securely in a `.env`/`config.yml` file (ensure it’s ignored by Git).

4. **Usage:**  
   ```bash
   python neversell_cli.py --interval 7d --amount 50
   ```
   - Buys $50 worth of BTC every 7 days. Check `--help` for options.

5. **Logging:**  
   - Outputs logs (timestamp, price, amount bought) to console or a log file.

6. **Stopping:**  
   - If running in a loop, you can stop it anytime with `Ctrl + C`. For long-term scheduling, consider OS-level schedulers or wait for our upcoming backend-based scheduling.

---

## Roadmap

We maintain a progressive roadmap to guide NeverSell’s development. **Phase 1** is completed; we now move on to **Phase 2**, focusing on mobile app and backend development with Docker-based deployment. Future phases (3–5) will expand advanced features and subscription models.

### **Phase 1 (Completed)**  
- [x] **Tech Stack Selection & Environment Setup** (Python CLI prototype)  
- [x] **Binance API Integration (Basic DCA)**  
- [x] **API Key Input & Secure Storage**  
- [x] **CLI DCA Execution & Logging**

### **Phase 2: Mobile App & Backend Development**

Below is the **updated** Phase 2 roadmap based on recent consulting and finalized stack decisions:

1. **Tech Stack Confirmation & Environment Setup**  
   - Install the Flutter SDK on Mac M1 (or your platform), set up iOS/Android emulators.  
   - Create a Python virtual environment for FastAPI, install necessary libraries (pytest, flake8).  
   - Initialize both the Flutter project and FastAPI project in a well-structured repository.  
   - Confirm usage of Docker, Docker Compose, and PostgreSQL.

2. **Refine Requirements & Design**  
   - Convert high-level ideas from Phase 1 into detailed specs.  
   - List all mobile app screens and corresponding API endpoints (e.g., login/signup, view item list, item details).  
   - Define data models (ERD) and user stories for each core feature.

3. **UI/UX Design & Prototyping**  
   - Create wireframes/mockups for main screens.  
   - Implement a consistent design system using Flutter’s Material/Cupertino widgets.  
   - If preliminary designs were done in Phase 1, refine and validate them here.

4. **Backend Core Feature Development (FastAPI)**  
   - Set up the PostgreSQL database schema (SQLAlchemy or FastAPI’s SQLModel).  
   - Implement authentication with JWT (OAuth2 password flow) for /auth/login and /auth/signup.  
   - Develop item-related APIs (e.g., /items for list, /items/{id} for detail, create/edit/delete) using Pydantic models.  
   - Write unit tests (pytest) for crucial logic (auth, business rules) and confirm via Swagger UI.

5. **Mobile App Development (Flutter)**  
   - Configure the Flutter project structure (routing, theming).  
   - Implement login/signup screens, integrate with the FastAPI endpoints (e.g., using the `dio` or `http` package).  
   - Securely store and attach JWT tokens in API requests.  
   - Build out main/item list screens, item details, and creation/edit features.  
   - Ensure consistent iOS/Android UX, handle platform-specific back buttons, etc.

6. **Integration Testing & QA**  
   - Test end-to-end flows between the Flutter app and FastAPI backend.  
   - Validate proper handling of edge cases (incorrect credentials, network issues).  
   - Fix bugs, refine error handling, consider simple performance checks (concurrent requests, DB indexing).  
   - Optimize Flutter release builds for speed and size.

7. **Docker Containerization**  
   - Write a Dockerfile for the FastAPI backend, test image build locally.  
   - Use Docker Compose to run FastAPI + PostgreSQL in a local dev environment.  
   - Document environment variables, ensure secrets (.env) are not baked into images.

8. **Initial Deployment (Cloud Instance)**  
   - Provision a small server (e.g., DigitalOcean Droplet or AWS EC2).  
   - Install Docker + Compose, deploy the FastAPI + PostgreSQL containers.  
   - Set up Nginx for reverse proxy (optionally Let’s Encrypt SSL).  
   - Verify the mobile app can reach the cloud API endpoint over HTTPS (e.g., https://api.neversell.com).

9. **Mobile App Release Preparation**  
   - Configure iOS TestFlight and Google Play Internal Testing.  
   - Update app icons, splash screens, privacy policy if needed.  
   - Deploy a beta (v0.1.0) to gather feedback from testers.  
   - Address store requirements (screenshots, metadata) and fix device-specific issues.

10. **Documentation & Next Steps**  
   - Update README with Phase 2 details, instructions for local dev vs. Docker.  
   - Finalize API docs (Swagger or a brief endpoint list).  
   - Refactor code for maintainability (remove TODOs, ensure consistent coding style).  
   - Outline plans for Phase 3 (advanced DCA, scaling, new features).

> **Goal of Phase 2:** By completing these steps, we will have a functional Flutter mobile app, a secure FastAPI backend with PostgreSQL, Docker-based deployment to a live server, and a beta release on app stores for internal testing.

### **Phase 3: DCA Strategy Enhancement & Feature Expansion**  
- [ ] **Strategy Research & Optimization** (vary purchase frequency/amount based on volatility, etc.)  
- [ ] **"Buy the Dip" Feature**  
- [ ] **Multi-Exchange & Wallet Support**  
- [ ] **Real-time Price Monitoring**  

### **Phase 4: Subscription Model & Commercialization**  
- [ ] **Payment System Integration** (Stripe Billing or similar)  
- [ ] **Subscription Tiers & Management**  
- [ ] **Auto Payment & Renewal**  
- [ ] **Additional Premium Features**  

### **Phase 5: Community & Open-Source Growth**  
- [ ] **Open-Source Guidelines** (CONTRIBUTING.md, PR templates)  
- [ ] **Documentation Expansion** (dedicated docs site, Wiki)  
- [ ] **Community Engagement** (Discord, Slack, GitHub Discussions)  
- [ ] **Feedback Integration**  
- [ ] **Project Launch & Marketing**  

---

## Contributing

Contributions are welcome! Feel free to open issues, submit PRs, or provide feedback. Please follow our guidelines:

- **Fork & Branch**: Create a feature branch for your changes.  
- **Code Style**: Adhere to PEP8 (Python) or recommended Dart style for Flutter.  
- **Pull Requests**: Provide a clear description of changes and reference relevant issues.  
- **Testing**: Add or update tests as needed (pytest for FastAPI, Flutter test for mobile).  
- **Discussion**: Use GitHub Issues/Discussions for questions or suggestions.

---

## Conclusion

With Phase 2 underway, **NeverSell** will transform from a basic CLI into a robust mobile app + backend service, complete with Docker-based deployment. By following this roadmap, we can steadily build a reliable DCA tool that helps users invest consistently without trying to time the market.

**Happy Investing, and Never Sell!**

---