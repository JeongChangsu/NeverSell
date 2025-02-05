[Click here for Korean version 🇰🇷](./README_ko.md)

# NeverSell

*NeverSell is an open-source application that automates recurring Bitcoin purchases (DCA – Dollar Cost Averaging) on crypto exchanges. It aims to help users steadily accumulate cryptocurrency without emotion-driven trading, essentially encouraging a "never sell" long-term mindset.* 

## Project Introduction

**NeverSell** enables users to connect to a crypto exchange (initially Binance) via API keys and schedule automatic periodic purchases of Bitcoin. The project will start as a simple Command Line Interface (CLI) tool for testing the core functionality, and then evolve into a full-fledged mobile app. The long-term vision includes support for multiple exchanges and wallets, more advanced DCA strategies (like buying extra on dips), and a subscription model for premium features. By automating crypto dollar-cost averaging, NeverSell helps investors avoid trying to time the market and instead consistently build their portfolio over time.

**Key Goals:**

- **Automate DCA Purchases:** Allow users to set up recurring buy orders on a schedule (e.g., daily/weekly Bitcoin buys) through exchange APIs, starting with Binance.  
- **Mobile App Accessibility:** Provide an easy-to-use mobile application so users can monitor and adjust their DCA settings on the go.  
- **Advanced Strategies:** In future updates, implement smart features such as a "buy the dip" option that executes extra purchases when prices drop significantly ([Why You Should Care About Dollar-Cost Averaging Your Crypto - Blockworks](https://blockworks.co/news/why-you-should-care-about-dollar-cost-averaging-your-crypto#:~:text=Being%20able%20to%20automatically%20buy,miss%20out%20on%20some%20gains))  as well as other strategy tweaks based on market conditions.  
- **Multi-Exchange Support:** Extend support to popular exchanges like Coinbase, Kraken, Bitfinex, etc., and possibly integrate with crypto wallets, so users can aggregate their DCA strategy across platforms.  
- **Subscription Model:** Eventually offer premium features through a subscription (e.g. advanced strategy customization, priority support), with secure payment integration (Stripe/PayPal) for sustainability.  
- **Community-Driven & Open Source:** Develop the project in the open, encouraging community contributions, feedback, and transparency. All core features will be free and open-source, with an option for users to support development via a subscription for added services.

## Tech Stack & Development

To achieve high productivity and code quality, we plan to use a modern, trending tech stack:

- **CLI Prototype:** For the initial MVP, we'll use **Python** due to its ease of use and rich ecosystem. Python has mature libraries for interacting with the Binance API (e.g. `python-binance`) which can speed up development. This allows quick testing of the DCA logic in a simple script. (Alternatively, Node.js could be considered here to later share code with a JavaScript-based mobile app, but Python offers a faster start for CLI tests.)

- **Mobile Application:** The mobile app will be cross-platform. We are evaluating **React Native** vs **Flutter** for this purpose. React Native, using JavaScript/TypeScript, offers rapid cross-platform development and a large community, whereas Flutter (Dart language) provides a highly consistent UI and excellent performance ([Flutter vs React Native: 2024년에 어떤 것을 선택해야 할까요? | UltaHost Blog](https://ultahost.com/blog/ko/flutter-%EB%8C%80-react-native/#:~:text=,%EC%84%B1%EB%8A%A5%EC%97%90%20%EB%B3%80%EB%8F%99%EC%9D%B4%20%EC%9E%88%EC%9D%84%20%EC%88%98%20%EC%9E%88%EC%8A%B5%EB%8B%88%EB%8B%A4))  React Native is a more mature technology with a broader ecosystem of libraries and developers, though it may require optimization for performance in complex scenarios ([Flutter vs React Native: 2024년에 어떤 것을 선택해야 할까요? | UltaHost Blog](https://ultahost.com/blog/ko/flutter-%EB%8C%80-react-native/#:~:text=%EA%B7%B8%EB%9F%AC%EB%82%98%20Flutter%EC%99%80%20%EB%B9%84%EA%B5%90%ED%95%A0%20%EB%95%8C%20React,%EC%9B%90%ED%99%9C%ED%95%9C%20%EC%86%94%EB%A3%A8%EC%85%98%EC%9D%84%20%EB%B0%9B%EA%B2%8C%20%EB%90%A0%20%EA%B2%83%EC%9E%85%EB%8B%88%EB%8B%A4))  Flutter has been rapidly growing in popularity and delivers near-native performance with a single codebase for iOS and Android. We will choose the framework that best balances development speed, community support, and app performance for NeverSell. (Native development in Kotlin/Swift is an alternative for maximum performance, but would double the development effort, so we prefer cross-platform for the MVP.)

- **Backend Services:** Initially, the app may call exchange APIs directly (from the CLI or mobile client). However, as features grow (scheduled background tasks, user account management, subscriptions), we anticipate introducing a lightweight backend. This could be built with **Node.js/Express** (leveraging JavaScript synergy with React Native) or **Python/FastAPI**. The backend would securely store user settings, schedule DCA jobs (so that buys can execute even if the app isn’t running), and handle subscription payments. A database (SQL or NoSQL) will be used if we need to persist user profiles, API keys (encrypted), and logs. We will design the system such that API keys are handled securely – possibly kept client-side for the basic version, or end-to-end encrypted if sent to a server.

- **Exchange Integration:** We use the official **Binance API** for trading. Going forward, to support multiple exchanges without rewriting lots of code, we can leverage a unified library like **CCXT** which supports over 100 crypto exchanges through a single interface ([What is CCXT? – Coinmetro Help Centre](https://help.coinmetro.com/hc/en-gb/articles/16351978148893-What-is-CCXT#:~:text=CCXT%20,Learn%20more))  This will greatly simplify adding exchanges like Coinbase, Kraken, Bitfinex, etc., and even various wallet services, by standardizing how we call their APIs.

- **IDE & Tools:** Contributors can use their preferred development environment, but we recommend **Visual Studio Code** for its versatility and rich plugin ecosystem. In particular, we suggest trying out AI-powered coding assistants to boost productivity. For example, **Cursor IDE** (an AI-enhanced fork of VS Code) integrates large-language-model capabilities directly into the editor, offering intelligent code completions and refactor suggestions that reduce cognitive load and accelerate development ([My New Favorite IDE: Cursor](https://www.mensurdurakovic.com/my-new-favorite-ide-cursor/#:~:text=Cursor%20IDE%20represents%20an%20innovative,difference%20when%20using%20Cursor%20IDE))  Tools like Cursor or GitHub Copilotcan automate boilerplate and help catch issues early, allowing developers to focus on core logic. Using such tools is optional but can be a great aid in a project of this scope.

By combining these technologies and tools, NeverSell's development will be efficient and the resulting app should be robust and scalable. We aim to use well-supported, popular frameworks to ensure maintainability and to attract open-source contributors familiar with these stacks.

## Installation & Usage

Currently, **NeverSell** is in an early stage. We have a prototype CLI tool available, and the mobile app is under development. Below are instructions for using the CLI and notes on the upcoming mobile app:

### CLI Version (MVP)

The CLI tool allows you to test basic DCA functionality on Binance.

1. **Prerequisites:** Ensure you have Python 3.x installed. You will need a Binance account with API keys (with trading permissions enabled). For security, *never enable withdrawal permission on the API key* and treat your keys with care.

2. **Installation:** Clone this repository to your local machine. Install the required Python libraries by running for example:  
   ```bash
   pip install -r requirements.txt
   ```  
   (The requirements file includes packages like `python-binance` for API access and any others needed for logging, etc.)

3. **Configuration:** Provide your Binance API Key and Secret to the application. You can do this by either:  
   - Setting environment variables `BINANCE_API_KEY` and `BINANCE_API_SECRET`, **or**  
   - Editing the config file (e.g., `config.yml` or `.env`) with your keys.  

   *Your API keys are stored locally and are **never** uploaded. The app will handle them securely in memory when executing trades.* 🔐

4. **Usage:** Run the CLI program to start the DCA process. For example:  
   ```bash
   python neversell_cli.py --interval 7d --amount 50
   ```  
   This would instruct NeverSell to buy $50 worth of Bitcoin every 7 days. The CLI supports options such as interval (daily/weekly/etc.), amount per purchase, target asset (default BTC), and perhaps exchange selection (future). You can also run `python neversell_cli.py --help` to see all available options.

5. **Logging:** The CLI will output logs to the console (and to a log file) for each purchase attempt. You’ll see information like timestamp of purchase, executed price, amount of BTC bought, etc. This helps in reviewing that the DCA is working as expected.

6. **Stopping:** If you started a continuous DCA process (e.g., a script that sleeps and repeats buys), you can stop it with Ctrl+C. In the future, we might support running as a background service or a cron job for automation.

*Note:* The CLI is mainly for initial testing and may not have a sophisticated scheduler. For long-running usage, consider using OS scheduling (cron/Task Scheduler) to invoke the CLI at desired intervals, or wait for our backend scheduling feature in a later update.

### Mobile App (Coming Soon)

The NeverSell mobile app is under active development. It will provide a user-friendly interface and additional features on top of the core DCA functionality.

**Planned features for the Mobile MVP:**

- Secure login and API key management within the app (API keys will be stored in encrypted storage on your device).
- A dashboard showing your DCA progress: total BTC accumulated, average purchase price, next scheduled buy, etc.
- Ability to start/stop or modify your DCA plan (frequency, amount) from the app.
- Notifications or alerts (optional) for each successful purchase or if an error occurs.
- All actions will be executed via the same backend logic used in the CLI, ensuring consistency.

Once the app is ready, you will be able to install it from the app stores (Android Play Store and iOS App Store for end-users). For developers or testers who want to run it from source, instructions will be provided (likely involving Node.js or Flutter SDK, depending on the framework chosen):

- If **React Native** is chosen: you'll need Node.js and `npm`/`yarn`. After pulling the code, run `npm install` to fetch dependencies, then use `npm run android` / `npm run ios` (or Expo CLI) to launch the app on an emulator or device.  
- If **Flutter** is chosen: you'll need the Flutter SDK. After pulling the code, run `flutter pub get` to install packages, then `flutter run` to start the app on an emulator or device.

We will update this README with precise build and installation steps for the mobile app as soon as they are available. Stay tuned! 🚀

## Contributing

Contributions are welcome and greatly appreciated! Being an open-source project, **NeverSell** thrives on community input—whether it's reporting bugs, suggesting features, or contributing code.

If you want to get involved, please follow these guidelines:

- **Project Setup:** Fork the repository and clone it to your machine. For the CLI part, ensure you have Python set up as described above. For the mobile app part, set up the appropriate environment (Node/React Native or Flutter SDK) once the choice is finalized. We recommend using an editor like VS Code (with relevant extensions for Python/Dart/JS) for a smooth experience.

- **Branching:** Create a new branch for your feature or bugfix (e.g., `feature/add-kraken-support` or `bugfix/fix-logging-path`).

- **Coding Style:** Try to follow the coding style and conventions used in the project. Write clear, concise code and comments where necessary. For Python, adhere to PEP8 style guidelines; for JavaScript/TypeScript, follow standard ESLint rules (we will include linter configurations). 

- **Commit Messages:** Write descriptive commit messages explaining the *what* and *why* of your changes.

- **Pull Requests:** When your feature or fix is ready, push your branch to GitHub and open a Pull Request (PR) to the `main` branch. Fill out the PR template (we will provide one) with details about your changes, and reference any relevant issues it addresses. Be open to feedback; maintainers may suggest changes or improvements.

- **Issues:** If you encounter a bug or have an idea for an enhancement, please open an issue on GitHub. Use the provided issue templates (bug report or feature request) to ensure we have the necessary details. Upvote 👍 existing issues that you find important to help us prioritize.

- **Discussion & Communication:** You can also join the project discussions (we might set up a Discord or Slack in the future) to talk with maintainers and other contributors. We aim to be a friendly community – all participants are expected to uphold our Code of Conduct (see `CODE_OF_CONDUCT.md`) and treat each other with respect.

- **Testing:** Where possible, please add tests for new features or fixes. We plan to include a test suite (using pytest for Python and appropriate testing frameworks for the mobile app) to catch regressions. Ensure that `pytest` (for CLI backend logic) and any unit tests for the app are passing before submitting your PR.

- **Documentation:** If your contribution changes how the app works or adds new options, update the relevant documentation. This could mean editing this README, the Wiki, or inline code comments. Clear documentation makes it easier for others to use and contribute to NeverSell.

By contributing to NeverSell, you agree that your contributions will be licensed under the same open-source license that covers the project. **Thank you for helping make NeverSell better!** 🤝

*(Open-source License: We plan to release NeverSell under the MIT License – see `LICENSE` file for details. This means you are free to use, modify, and distribute the code, but with no warranty. We chose MIT to encourage broad usage and contribution.)*

## Roadmap

We maintain a progressive roadmap to track NeverSell's development milestones. The roadmap is structured in phases, each with a set of tasks. Completed tasks will be checked off. This roadmap is also present in our README to keep users informed of our progress and upcoming features.

**Phase 1: Initial Test and MVP (CLI-based)**  
- [ ] **Tech Stack Selection & Environment Setup:** Decide on the programming language and tools for the MVP, and configure the development environment (choose an IDE, set up project structure, etc.). *_(For the prototype, Python was chosen for quick development; using VS Code with Cursor AI for codin ([My New Favorite IDE: Cursor](https://www.mensurdurakovic.com/my-new-favorite-ide-cursor/#:~:text=Cursor%20IDE%20represents%20an%20innovative,difference%20when%20using%20Cursor%20IDE)) 70】*  
- [ ] **Binance API Integration (Basic DCA):** Connect to the Binance API using the user’s API key and implement the core logic to execute a buy order at fixed intervals. This will likely utilize Binance’s SDK/REST endpoints to purchase BTC in small increments.  
- [ ] **API Key Input & Secure Storage:** Implement a secure method for the user to input their API key (for example, via prompt or config file) and store it safely (e.g., in an environment variable or encrypted file). **Security is a priority** – ensure the key is not exposed in logs or error messages.  
- [ ] **CLI DCA Execution & Logging:** Allow the CLI tool to run the DCA process (perhaps in a loop or via scheduling). Provide console output and log file writing for each operation (time, amount, price, success/error). Test the process with a small amount to ensure it works reliably.

**Phase 2: Mobile App Development (First Release)**  
- [ ] **Framework Selection (React Native vs Flutter vs Native):** Evaluate which mobile framework to use by comparing development speed, performance, and community support. *_(React Native offers rapid development and a huge ecosystem, whereas Flutter provides a consistent high-performanc ([Flutter vs React Native: 2024년에 어떤 것을 선택해야 할까요? | UltaHost Blog](https://ultahost.com/blog/ko/flutter-%EB%8C%80-react-native/#:~:text=,%EC%84%B1%EB%8A%A5%EC%97%90%20%EB%B3%80%EB%8F%99%EC%9D%B4%20%EC%9E%88%EC%9D%84%20%EC%88%98%20%EC%9E%88%EC%8A%B5%EB%8B%88%EB%8B%A4)) 40】. We'll choose the best fit for NeverSell’s need ([Flutter vs React Native: 2024년에 어떤 것을 선택해야 할까요? | UltaHost Blog](https://ultahost.com/blog/ko/flutter-%EB%8C%80-react-native/#:~:text=%EA%B7%B8%EB%9F%AC%EB%82%98%20Flutter%EC%99%80%20%EB%B9%84%EA%B5%90%ED%95%A0%20%EB%95%8C%20React,%EC%9B%90%ED%99%9C%ED%95%9C%20%EC%86%94%EB%A3%A8%EC%85%98%EC%9D%84%20%EB%B0%9B%EA%B2%8C%20%EB%90%A0%20%EA%B2%83%EC%9E%85%EB%8B%88%EB%8B%A4)) 52】*  
- [ ] **UI/UX Design & Dashboard:** Design an intuitive user interface. Implement a simple dashboard screen showing the user's Bitcoin balance (or amount accumulated via NeverSell), next scheduled buy, and basic controls. Emphasize clarity and simplicity for ease of use.  
- [ ] **Mobile API Integration:** Connect the mobile app to the Binance API (or through our backend, if ready) so that users can start/stop the DCA from their phone. Ensure that API keys are handled securely on the device (using secure storage provided by the OS).  
- [ ] **User Authentication:** Implement a login/signup system for the app. This could be a simple email/password or OAuth if a backend exists. Initially, this might be optional if the app stores everything locally, but for syncing across devices and future cloud features, an account system is needed.  
- [ ] **Mobile MVP Release:** Publish the first version of the mobile app to app stores (or as a public test via TestFlight/Google Play Beta). Gather user feedback on the app’s functionality and fix any critical issues.

**Phase 3: DCA Strategy Enhancement & Feature Expansion**  
- [ ] **Strategy Research & Optimization:** Analyze market data and research ways to optimize the DCA approach. This may include varying the purchase frequency or amount based on volatility, or pausing buys during extreme conditions, etc. The goal is to improve outcomes while maintaining a simple user experience.  
- [ ] **"Buy the Dip" (DIP) Feature:** Implement an option to allocate extra funds to buy when the market dips by a certain percentage. For example, users could specify: "If BTC drops more than 5% in 24h, execute an additional buy of $X." This leverages the dip-buy opportunity to enhance returns, addressing a common critique of strict ([Why You Should Care About Dollar-Cost Averaging Your Crypto - Blockworks](https://blockworks.co/news/why-you-should-care-about-dollar-cost-averaging-your-crypto#:~:text=Being%20able%20to%20automatically%20buy,miss%20out%20on%20some%20gains)) 28】. Ensure users have sufficient stablecoin balance for this feature and perhaps integrate a notification when a dip buy occurs.  
- [ ] **Additional Strategies:** Research and possibly add other automated strategies, such as periodic rebalancing, take-profit or stop-loss triggers for those who want some selling functionality (even though the app is called NeverSell, some users might want to occasionally cash out gains – this can be a debated feature). Each new strategy will be optional and clearly explained to users.  
- [ ] **Multi-Exchange & Wallet Support:** Extend support beyond Binance. Using a unified API like CCXT, integrate at least 2-3 more exchanges (Coinbase, Kraken, Bitfinex as high priority). This involves mapping the DCA functionality to those exchanges’ APIs and testing accordingly. Also, consider connecting to wallet services or DeFi platforms if users want to DCA from a non-custodial wallet (this might be complex and possibly a later idea). *_(By using a library such as CCXT, which supports 100+ exchanges via one interface, this process can be streaml ([What is CCXT? – Coinmetro Help Centre](https://help.coinmetro.com/hc/en-gb/articles/16351978148893-What-is-CCXT#:~:text=CCXT%20,Learn%20more)) 47】.)_*
- [ ] **Real-time Price Monitoring:** Incorporate a background service or use exchange websockets to monitor crypto price in real-time. Use this to trigger the dip buys or to alert users of significant market moves. Also, if the user wants to adjust their DCA (pause or increase buys) when certain conditions are met, real-time data is needed. This task might also involve optimizing the app’s performance so constant price checks don’t drain device battery (for mobile) or overload the system.

**Phase 4: Subscription Model & Commercialization**  
- [ ] **Payment System Integration:** Implement a subscription system for premium features. Likely use **Stripe Billing** for handling recurring payments, as it easily integrates with apps and provides a robust subscription management ([Stripe Billing | Recurring Payments & Subscription Management](https://stripe.com/billing#:~:text=Building%20blocks%20for%20recurring%20billing)) 38】. This will involve setting up plans (monthly/yearly), a checkout flow in the mobile app or web, and secure backend validation of paid users. (We will ensure compliance with app store rules – e.g., using in-app purchases if required for iOS or using external payments if allowed for services.)  
- [ ] **Subscription Tiers & Management:** Define what premium tiers offer (for example, a free tier with basic DCA on one exchange, and a premium tier with multiple exchanges, advanced strategies, and priority support). Implement in-app gating for premium features and a way for users to upgrade/downgrade. Also handle edge cases like failed payments, grace periods, and renewal reminders.  
- [ ] **Auto Payment & Renewal:** Enable automatic billing through the chosen payment platform. This includes sending reminders or notifications for expiring payment methods, handling cancellations, and ensuring a smooth user experience for managing their subscription within the app (view status, next billing date, etc.).  
- [ ] **Additional Premium Features:** To add value for subscribers, consider features such as: integration with interest-bearing accounts for unused funds (e.g., automatically move idle USD to a yield-bearing stablecoin account and use it for DCA), advanced analytics of DCA performance, or the ability to DCA into multiple assets/portfolios. These features will be developed if there is user demand and as resources allow.

**Phase 5: Community & Open-Source Growth**  
- [ ] **Open-Source Guidelines:** Formulate clear guidelines for external contributors. This includes setting up a CONTRIBUTING.md with instructions (much like the Contributing section above), creating pull request and issue templates on GitHub, and adopting a Code of Conduct. The goal is to make it easy for new contributors to understand how to get involved and the expectations for contributions.  
- [ ] **Documentation Expansion:** Create thorough documentation for using NeverSell and for developing on it. This might involve a dedicated docs site or wiki covering setup, FAQs, architecture overview, etc. Also, a **Contributor Guide** should outline the project structure, coding conventions, and release process to help onboard developers.  
- [ ] **Community Engagement:** Establish channels for the community to interact. For example, a Discord server or GitHub Discussions for Q&A, announcements, and general support. Regularly update the community on progress (perhaps via a monthly update post or release notes). Encourage users to share feedback and ideas.  
- [ ] **Feedback Integration:** Actively listen to user feedback and bug reports. Prioritize fixes and feature improvements based on community input. The roadmap itself will be updated over time reflecting the community’s needs and the project’s lessons learned.  
- [ ] **Launch & Marketing:** As NeverSell becomes stable and feature-complete, focus on growing its user base. This might include writing blog posts about its features, doing a Product Hunt launch for the app, or partnering with crypto communities to spread the word. While this is beyond pure development, it's part of ensuring the project thrives and reaches those who can benefit from it.

---

**Legend:** Tasks with a checkbox ([ ]) are planned or in progress. Once a task is completed, it will be marked as done ([x]). This roadmap is subject to change; it’s a living document that evolves with the project. New ideas might be added and priorities may shift as we gather more feedback.

## Conclusion

NeverSell is an ambitious project at the intersection of crypto investing and automation. By following this roadmap, we plan to iterate from a simple prototype to a comprehensive platform that makes crypto DCA effortless for anyone. We believe in the power of consistent investing and the value of community-driven development. With the chosen tech stack and the support of contributors, we’re confident about building a reliable and innovative DCA assistant for crypto enthusiasts.

We hope you'll join us on this journey. 🙌 **Happy Investing, and Never Sell!**