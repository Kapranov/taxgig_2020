defmodule Core.Seeder.Landing do
  @moduledoc """
  Seeds for `Core.Landing` context.
  """

  alias Core.{
    Landing,
    Landing.Faq,
    Landing.FaqCategory,
    Landing.PressArticle,
    Landing.Vacancy,
    Repo
  }

  @marketing_director %{
    title: "Marketing Director",
    department: "Marketing",
    content:
      "\n TaxGig aims to ease the pain of preparing your tax returns by outsourcing it to certified tax professionals. While there are many other players in the market, we believe that our deep understanding of both taxpayers’ and tax professionals’ needs makes our product singular and appealing. However, true specialists know that even the best ideas cannot succeed and win the hearts of others without a proper marketing. In this world of noise, it is important to make your message clear and outstanding, may it be a full-scale campaign or just a Facebook post. Anything can create its impact. \n
        \n Therefore, we are in search of such person, who will help spread the word about TaxGig and what we offer to ease the pain of tax preparation. You will be leading our Marketing campaign and work closely with founders. \n

        \n ## Responsibilities: \n
        \n Researching and identifying key marketing chains to grow our audience \n
        \n Leading and providing strategic guidance on marketing campaign \n
        \n Analyzing and communicating with media, target audiences and influencers \n
        \n Overseeing and producing content before publishing \n
        \n Developing our key messages and ensuring we stay in consistence with them and maintain the same position throughout  \n
        \n Providing product representation when needed at public events \n

        \n ## Requirements: \n
        \n 3+ years in marketing, preferably in SaaS, with strong background in Content Marketing and Marketing Communications \n
        \n Experience in creating marketing content across several disciplines (text, design, video, etc.) and media (blog, whitepapers, research, infographics, etc.) \n
        \n Masters Degree in Business or Marketing \n
        \n Ambitious, proactive, and result-oriented team player with a strategic mindset \n
        \n An open mind with a positive attitude \n

        \n ## We offer: \n
        \n Interesting and challenging work \n
        \n An international and multicultural working environment with experienced and enthusiastic colleagues \n
        \n Plenty of opportunities to learn, grow and progress in your career \n
        \n Flexible working hours \n
        \n Paid vacations, days off and sick leaves \n
        \n PE (Private Entrepreneur/Sole Proprietor) accounting and support \n
        \n Corporate library, tech talks, conferences and other opportunities to broaden your knowledge \n
        \n The ability to focus on your work: a lack of bureaucracy and micromanagement, and convenient corporate services \n
        \n Friendly atmosphere, concern for the comfort of specialists \n
        \n Stock option \n
"
  }

  @react_dev %{
    title: "ReactJS Developer (field - position)",
    department: "Development",
    content:
      " \n TaxGig - is the first online marketplace solely dedicated to tax preparation services. As great projects require great people, we are looking for such one to join our front-end development team. \n

    \n You will develop brand new features with a distributed team and should be proactive in terms of proposing new ideas. You will be working with the founders and other stakeholders in a highly collaborative manner. Together with Hong Kong engineers, you are going to develop a new solution for tax preparation services. \n

    \n ## Responsibilities: \n
    \n Collaboration with other Front-end & Back-end developers to build and ship features \n
    \n Requirements’ elicitation, breaking down real-world problems into smaller pieces and technical tasks \n
    \n Research, review and test new technology \n
    \n Demonstrate exceptional programming skills, as well as passion in building elegant, intuitive and functional user interfaces \n


    \n ## Required Skills and Experience: \n
    \n Strong modern JavaScript skills (ES 6 or above) \n
    \n Strong React skills, at least 1+ years of experience \n
    \n Understanding of state-management patterns such as Redux \n
    \n Feeling comfortable in working with the latest CSS & HTML standards \n
    \n Version control systems (GIT) \n
    \n Genuine interest to keep up to date with the latest technologies and trends \n

    \n ## Highly Desirable: \n
    \n Experience with functional programming languages \n
    \n Experience with test driven development (TDD) \n
    \n Build tools such as Webpack or Parcel \n
    \n Familiarity with test frameworks (Jest, Enzyme, Mocha etc.) \n
    \n Experience with CSS preprocessors such as SASS, PostCSS or CSS Modules \n
    \n Knowledge of continuous integration processes (Jenkins), containers (Docker) \n
    \n Demonstrable understanding of user experience (UX) & best practices \n
    \n Experience with agile methodologies (preferably SCRUM) \n
    \n Strong Computer Science fundamentals \n

    \n ## Personal requirements: \n
    \n Solid writing English (Upper Intermediate or higher) \n
    \n Team player with good communication skills \n
    \n Customer focused; caring about the end result, not just the technical side \n
    \n An open mind and a positive attitude \n
    \n Goal oriented and self-motivated with a business mindset \n

    \n ## We offer: \n
    \n Interesting and challenging work \n
    \n An international and multicultural working environment with experienced and enthusiastic colleagues \n
    \n Plenty of opportunities to learn, grow and progress in your career \n
    \n Flexible working hours \n
    \n Paid vacations, days off and sick leaves \n
    \n PE (Private Entrepreneur/Sole Proprietor) accounting and support \n
    \n Corporate library, tech talks, conferences and other opportunities to broaden your knowledge \n
    \n The ability to focus on your work: a lack of bureaucracy and micromanagement, and convenient corporate services \n
    \n Friendly atmosphere, concern for the comfort of specialists \n
    "
  }

  @what_is_taxgig %{
    title: "What is TaxGig?",
    content:
      "# What is TaxGig? \n TaxGig is a marketplace for tax related services. Instead of wasting thousands of hours attempting to do it yourself, TaxGig offers to prepare them quickly, correctly and at a fair price by finding your perfect match from our pool of verified professionals. \n
    \n 1. Answer simple questions and get a price upfront. \n
    \n 2. Whether you choose our pre-selected Pro or decide to find one on your own - we guarantee that you will be working with verified professionals who suit your needs. \n
    \n 3. Upload all necessary documents that you need and your Pro suggests.  \n
    \n 4. Relax and enjoy your time, while your Pro does the rest. \n
    "
  }

  @regular_filer %{
    title: "My taxes are fairly simple. Should I use TaxGig?",
    content:
      "# My taxes are fairly simple. Should I use TaxGig? \n TaxGig’s Pros have a variety of skills and are capable of dealing with both simple and complicated tax situations. \n
\n They can prepare your tax documents, help with tax planning and file tax returns on your behalf. Furthermore, if you select a licensed Pro (CPA, EA, ATTY), they are eligible to represent you in the IRS if any questions about your tax return arise. \n
\n Tax Pros can help you avoid mistakes when dealing with tax changes. If you qualify for itemized deductions or have a small business on the side, a licensed professional can help you understand the new TaxCuts and Jobs Act and its effect on you. \n
\n Even though you want to apply for as many deductions as possible, you don’t want to trigger an audit from the IRS if your eligibility is questionable for some of them. Child and Dependent Tax Credit is among the most efficient tools to reduce your tax liability, and our Pros will help you identify whether you qualify or not. \n
\n Due to the competitive nature of our platform, the average service price is lower than the one on the market. You are free to find your perfect Pro from our pool of verified tax professionals or go along with a TaxGig Hero - our pre-selected Pros who are the best on the platform. \n
"
  }

  @business_owner %{
    title: "I am a business owner. Can TaxGig help me?",
    content:
      "# I am a business owner. Can TaxGig help me? \n The best business requires the best help. Whether you just started a new business or operating one for years now, one thing is for sure - you need to have a good trusted accountant by your side. \n
\n First of all, business taxes are very different from personal ones. Depending on the size of the business and/or if you sold your products in multiple states or even countries, taxes will only get more complicated. Our Pros will help you avoid paying extra dollars and suggest different strategies to lower your business’ tax liability for the years to come, especially after the adoption of  the Tax Cuts and Jobs Act. \n
\n Second, operating a business requires a lot of day-to-day work and record keeping. Having an in house accountant adds a lot of extra costs to your business. Bookkeeping, payroll, sales tax - outsourcing it to one of our Pros will save you money and bring additional benefits. \n
\n We match you with Pros who have the best skills and knowledge to help your business prosper. \n
"
  }

  @non_resident_and_expat %{
    title: "Non-resident alien, International student or an American working abroad?",
    content:
      "# Non-resident alien, International student or an American working abroad? \n These types of taxes are complicated and hard. If you just moved to the US for work or found a paid internship/side job as a student, by the end of the year you’ll have to deal with this scary word 'taxes' for the first time. The US tax code is much more complicated than in the rest of the world, but it provides a lot of tax deduction and tax credit opportunities. Having to deal with it by yourself will bring more stress and the possibility of making a mistake may result in undesirable problems with the IRS. Existing do-it-yourself software does not provide enough help in this situation. Our Pros will take away your pain and file taxes on your behalf, which will save you money and time. \n
\n If you earned income abroad at some point of the year or moved to another country for work, you are still obliged to pay taxes and report your income to the IRS as an American citizen. Our Pros will prevent you from paying extra and will ease the tax return preparation. \n
\n Stop worrying about getting everything right and let our tax Pros help you out. \n
"
  }

  @freelancer_uber_lyft %{
    title: "Self-employed, Freelancer, Uber/Lyft driver or Trucker?",
    content:
      "# Self-employed, Freelancer, Uber/Lyft driver or Trucker? \n When you have a lot of things going on in your life, the smartest choice is to hand your taxes to a Pro. Working for yourself allows you to be your own boss, working with whom you want and where you want. However, such independence also comes with a certain price. Whether you have rental property, earned income in different states and/or used your vehicle to perform work-related activities - our Pros will help identify and calculate all the possible deductions to reduce your tax liability and ease the tax filing process overall. \n
\n Our pool of experts will deal with your taxes and bookkeeping to let you get back to doing your business. \n
"
  }

  @who_are_the_pros %{
    title: "Who are the Pros?",
    content:
      "# Who are the Pros? \n Our professionals can only get access through verification of their identity and PTIN. We do that via Blockscore (that verifies SSN and performs a background screening on Criminal Records and Sexual Assaults) and via IRS database, that has lists of people granted with permission to prepare taxes and whether or not having certified credentials. \n
\n Our Pros include CPAs, EAs, Attorneys and those who were granted permission to prepare taxes via IRS (PTIN holders). \n
\n All qualifications will be visible in each Pro’s profile when browsing. Our TaxGig Heroes are the Pros who are certified with CPA, EA or Attorney credentials and have successfully fulfilled the requirements to become a TaxGig Hero. \n
"
  }

  @how_it_works %{
    title: "How it works?",
    content:
      "# How it works? \n TaxGig values your time the most. Instead of wasting thousands of hours attempting to do it yourself, TaxGig offers to delegate your most sensitive and painful part of life to our pool of verified professionals. \n
\n All you need to do is to answer simple questions, select a Pro and upload all necessary documents. Your Pro will find all possible deductions and suggest on how to get a maximum refund. You can enjoy your life and do whatever you need to do, while your Pro will do the job for you. \n
\n  1. Answer simple questions and get a price upfront. \n
\n 2. Whether you choose our pre-selected Pro or decide to find one on your own - we guarantee that you will be working with verified professionals who suit your needs. \n
\n 3. Upload all necessary documents that you need and your Pro suggests. \n
\n 4. Relax and enjoy your time, while your Pro will do the rest. \n
"
  }

  @is_taxgig_free %{
    title: "Is TaxGig free?",
    content:
      "# Is TaxGig free? \n TaxGig is absolutely FREE to join! TaxGig does not ask for any payment to get access to the platform. You can browse through the list of our professionals and see upfront estimates for your return for free. \n
\n You will only be asked to add a card/bank account details and make a partial upfront payment when you start working with a Pro. \n
"
  }

  @filing_as_non_resident %{
    title: "Filing as a non-resident alien",
    content:
      "# Filing as a non-resident alien \n Did you just move to the US for work or study and the word 'taxes' sounds like something horrible? No need to worry! TaxGig is here to provide you with professionals experienced in preparing non-resident alien returns. Make sure to state that in the questionnaire to be matched with qualifying Pros. \n
\n Don’t stress about taxes, let our Pros help you. \n
"
  }

  @filing_for_multiple_years %{
    title: "Filing for multiple years",
    content:
      "# Filing for multiple years \n Not a problem! Just indicate the years needed filing at the end of the questionnaire. If different years need to have a different filing status, it is best to create separate tax return projects. \n
"
  }

  @state_return %{
    title: "State returns",
    content:
      "# State returns \n If you earned income in different states, you can select them in the questionnaire. If you earned income outside of the US, just indicate it as well. Our Pros have an experience in filing for all types of tax returns. \n
"
  }

  @multiple_tax_returns_in_progress %{
    title: " Can I have multiple tax returns in progress?",
    content:
      "# Can I have multiple tax returns in progress? \n Yes! You can have as many as you require. Business and Individual returns go separately, unless you are a sole proprietor - then it will go along with the Individual form. Furthermore, you can have separate individual returns, if different years require different filing status. \n
"
  }

  @itemizing_deductions %{
    title: "Itemizing deductions",
    content:
      "# Itemizing deductions \n We encourage you to communicate with your Pro when matched. The more information they are provided with, the better their service is going to be. If you feel that you can benefit from itemizing your deductions, let your Pro know that in the questionnaire and during the communication. \n
"
  }

  @business_tax_returns %{
    title: "Business tax returns",
    content:
      "# Business tax returns \n Regardless of your business size, TaxGig has Pros that can help with any requirement. Just make sure to select the type of entity needed filing and specify necessary details in the questionnaire. We will match you with the best qualifying Pros for your return. Furthermore, we can assist you with bookkeeping and sales tax as well, if required - just create another project for the selected service. \n
"
  }

  @requesting_services_outside_taxgig %{
    title: "Requesting services not listed on TaxGig",
    content:
      "# Requesting services not listed on TaxGig \n TaxGig works every day to improve our platform and add new services. As of now, we do not have occupancy tax assistance, quarterly estimates or incorporation services yet. However, you can always ask your Pro if he/she provides those. Your Pro will use add-ons to include additional service charge to your quote. \n
"
  }

  @contact_my_pro_outside_taxgig %{
    title: "Can I contact my Pro outside of TaxGig?",
    content:
      "# Can I contact my Pro outside of TaxGig? \n Unfortunately, this would be a violation of our Terms of Usage. TaxGig can guarantee the security of your documents and payment only within the platform. We use encryption for shared files and have specific policies to prevent fraud and identity theft. \n
\n If you choose to take your return outside of the TaxGig, it won’t be secure and the following penalties will apply. \n
"
  }

  @choose_same_pro_next_project %{
    title: "Can I choose the same Pro to work on my next project?",
    content:
      "#Can I choose the same Pro to work on my next project? \n Yes, you can. TaxGig knows that finding a right tax professional is like finding a right personal doctor. The candidate must perfectly match your needs and know all the details about you. Therefore, helped by AI, we pre-select the best matching Pros for you and show other candidates who might be of great fit. Our goal is to help you find the perfect tax professional. \n
\n If you like the services provided, you can continue working with the same Pro. To do so, go to your project that was closed with the preferred Pro and press **Create Project** button. It will be automatically sent to your Pro for him/her to send a new quote for the service.  \n
"
  }

  @use_taxgig_outside_the_us %{
    title: "Can I use TaxGig outside the US?",
    content:
      "# Can I use TaxGig outside the US? \n Yes, you certainly can access the service outside of the US. TaxGig is here to help you fulfill your obligations with the IRS, regardless of your current location. \n
\n Filling from abroad may be difficult and uncomfortable, that’s why we have created this platform to ensure easy and fast communication between you and your tax professional. Just identify your status of filling from abroad via questionnaire when creating a project. \n
"
  }

  @how_taxgig_differs_from_diy %{
    title: "How does TaxGig differ from do-it-yourself software?",
    content:
      "# How does TaxGig differ from do-it-yourself software? \n Instead of wasting thousands of hours attempting to do it yourself, TaxGig offers a service to prepare taxes quickly, correctly and at a fair price by finding you a perfect match from our pool of verified professionals. \n
\n You no longer have to stress about getting everything right and on time. Our Pros are here to help with preparing and filing your return, so you can relax and go back to whatever you’ve been doing. \n
\n Due to the competitive nature of our product, the average price for tax preparation services is way lower than on the market. You decide with whom to work and on what terms. We do not dictate the price like H&R Block, Intuit and others. \n
"
  }

  @when_get_quote %{
    title: "When do I get a quote?",
    content:
      "# When do I get a quote? \n All you need to do is answer a simple questionnaire. At the last step, you will be provided with a choice - to work with our pre-selected Pro or find the one on your own. \n
\n For an **Instant Match**, the price will be available right away. If you want to find one by yourself, we will show you the average prices for Pros’ services based on what you answered. In this case, the final quote will be sent by your Pro before the cooperation between you starts. \n
"
  }

  @pay_upfront %{
    title: "Do I need to pay upfront?",
    content:
      "# Do I need to pay upfront? \n You are free to use and browse through the platform. You will only have to make a payment when engaging with a Pro. We will deduct 35% of the quote and put it into an escrow account. No worries, your payment will only be released to a Pro when the deal is closed. \n
\n We use an escrow method to prevent scam and ensure the safety of the transaction to prevent any disputes between you and your Pro. \n
"
  }

  @client_wants_to_cancel %{
    title: "What if I want to cancel my project and terminate the cooperation with my Pro?",
    content:
      "# What if I want to cancel my project and terminate the cooperation with my Pro? \n You may cancel your project at any time by pressing the **Cancel** button while in the Open **Project** screen. Please be aware of these rules, if you decide to cancel: \n
* In the first 2 hours after you have been assigned with a Pro to work on your project (when project is Assigned) - your money will be returned with **no penalty** (only includes a Stripe fee).
* After 2 hours and before the Pro uploaded any documents to a Final document section - you will have to pay **35% of the quote** as a penalty.
* After a Pro uploaded any documents to a Final document section - you will have to pay **75% of the quote** as a penalty but can **leave a review** for the Pro.
\n If you were not satisfied with service after the deal is already closed, please contact our team via support@taxgig.com to resolve the matter together. \n
"
  }

  @answer_question_incrorrectly %{
    title: "What if I answer a question incorrectly?",
    content:
      "# What if I answer a question incorrectly? \n You can always cancel your project before selecting a Pro. At this stage, you can edit all the answers and information related to it. When done, simply renew the project. Please note that quotes will change based on the information changed. \n
\n If you have already started working with a Pro, please notify your Pro about the mistake. Your Pro will recalculate the quote for you. If it requires additional payment, simply accept add-ons that your Pro sends you. \n
\n If the new quote is lower than the original one, please contact support@taxgig.com to resolve the matter. \n
"
  }

  @how_quote_generated %{
    title: "How is the quote generated?",
    content:
      "# How is the quote generated? \n Each Pro has a price list for each service. The quote is generated based on the responses you provide. However, additional fees may apply if new information and requirements come up during your cooperation with a Pro. \n
\n If you chose to work with **TaxGig Hero**, then your quote will be shown right away. If you want to find a Pro by yourself, we will show average prices for Pros’ services based on what you answered. In this case, the final quote will be sent by your Pro before the cooperation between you starts. \n
"
  }

  @will_my_quote_change %{
    title: "Will my quote change?",
    content:
      "# Will my quote change? \n Your quote may be changed only if the information provided during the questionnaire was not complete or you require additional services not stated initially.  Your Pro will recalculate the quote. \n
\n If it requires extra payment, your Pro will send you add-ons. You can accept or decline them. \n
\n Please remember that if you don't come to a mutual agreement, TaxGig may intervene upon request as a mediator to resolve a dispute. \n
\n If the new quote is lower than the original one, please contact support@taxgig.com to resolve the matter. \n
"
  }

  @fee_from_refund %{
    title: "Can the fee be taken out of my tax refund?",
    content:
      "# Can the fee be taken out of my tax refund? \n Unfortunately, we are not there yet and cannot deduct the fees from your tax refunds. We are always working on improving TaxGig’s experience and will resolve this issue in the nearest future. \n
\n However, the IRS has significantly improved its e-file process so that you can expect electronically filed returns within 5 to 10 days after the submission. Most refunds are processed and returned within 21 calendar days.  \n
"
  }

  @credit_card_billed_dollar %{
    title: "Why was my credit card just billed for a few dollars?",
    content:
      "# Why was my credit card just billed for a few dollars? \n This is a standard procedure to verify the new payment method. This money will be automatically returned when the card/bank account is approved. \n
\n If your project is Assigned (meaning you already matched with a Pro), we charge a fixed 35% fee of the quote which is put into an escrow account. If you wish to cancel the project, please read our cancellation policy carefully first. \n
"
  }

  @how_project_routed_to_pro %{
    title: "How is my project routed to the right Pro?",
    content:
      "# How is my project routed to the right Pro? \n We ask Pros to describe their previous work experience and identify job preferences, so we can help our algorithms to match you perfectly. Even if you find a Pro on your own rather than using the one we have pre-selected, the Pros shown will still match the service you require. This will help you to find your Pro much faster and still get the perfect match you seek. \n
"
  }

  @relationship_with_pro %{
    title: "What is my relationship with my Pro?",
    content:
      "# What is my relationship with my Pro? \n Your tax Pro is an independent third party who has been vetted and background checked by TaxGig. Furthermore, if your Pro is a CPA, EA or Attorney, we will verify their credentials as well. Any Pro is free to engage or reject the work within TaxGig on their own and at absolute discretion within their own preferred schedule. When you start your engagement with a Pro, you will share all of the relevant information with him/her regarding your tax activity via chat and **Documents** section. When the job is done, you will rate your Pro based on our rating system. It helps us ensure the high quality of every Pro on the platform.  \n
\n We understand that finding a proficient tax professional is similar to finding the right personal doctor - it is very hard and intimate. Therefore, we built this platform to ease the search for a perfect match. Even though we prohibit external communication outside of the TaxGig platform to ensure the security of the data shared and quality of delivered professional service, you are encouraged to work with the same Pro on your new projects. This recurring engagement will bring additional benefits for both parties, like discounts and lower commission. \n
"
  }

  @if_unhappy_with_service %{
    title: "What if I'm not happy with the service?",
    content:
      "# What if I'm not happy with the service? \n If you are not happy with the service, you can cancel it at any time. However, please remember the penalties stated in our cancellation policy. We have created standardized rules and procedures to ensure that both parties are treated properly during any engagement within the platform. If negligence is involved, then Pros will not get paid for the work. \n
\n If any issues arise before, during or after your engagement with a Pro, be sure to notify us via email at support@taxgig.com, so we can resolve the matter together. \n
"
  }

  @how_long_is_the_match %{
    title: "How long should I wait to get a match with a Pro?",
    content:
      "# How long should I wait to get a match with a Pro? \n If you go with **TaxGig Hero** when choosing a Pro, it will only be a matter of seconds. If a matching Tax Hero is online, you will connect momentarily. However, if your project is submitted outside the regular working hours (like at night or early morning EST), it may take a minute or two to find you a perfect match and get your Pro online. \n
\n If you found a Pro on your own, most professionals are people with similar schedules to yours. Pros may not respond right away at late nights or early mornings. In the rest of the time, they usually respond quickly. \n
"
  }

  @when_will_complete %{
    title: "When will my project be completed?",
    content:
      "# When will my project be completed? \n It depends on the complexity of your project and whether all the information was provided at the beginning of the engagement or not.  \n
\n Simple tax returns may be prepared within a couple of hours, whereas more complicated ones or a monthly bookkeeping may require up to a week. Please ensure that you fully describe your tax situation and/or required service right away to your Pro and provide all the necessary documentation. The sooner it is done, the faster your project will be prepared. \n
\n If you requested a tax return, do not forget to electronically sign your final document for a Pro to e-file it on your behalf. If you do not do so in 48 hours after your Pro uploaded the final document, the deal will be closed, and you will have to file it on your own. \n
"
  }

  @tax_extention_service %{
    title: "Can I get a tax extension via TaxGig?",
    content:
      "# Can I get a tax extension via TaxGig? \n Yes, you can. Simply mention it in the **Additional Comments section** at the end of the questionnaire for your Pro to understand that you require a tax extension form when deciding to work on your tax return. \n
"
  }

  @how_taxgig_works %{
    title: "How TaxGig works?",
    content:
      "# How TaxGig works? \n TaxGig is a marketplace for tax related services. Stop wasting hours on searching for new clients via your family, friends, LinkedIn or by using online advertising -  on TaxGig clients will be looking for YOU. With the help of intelligent algorithms, you will be matched only with people who require your particular expertise - the process is easy and fast. \n
\n Furthermore, our platform offers you a transparent competition and interaction with clients, as well as an individual approach to each of your needs. You don’t have to work for somebody else no more - with TaxGig you can be your own boss, working whenever you want and with whom you want.  This is a list of super easy steps to get you started: \n
\n 1. Fill in your personal and background information to set up your profile. \n
\n 2. Identify the services you provide and at what price. \n
\n 3. Explore job opportunities or get instantly matched to clients by enabling our premium feature 'TaxGig Hero'. \n
\n 4. Identify the amount of work required and send a quote. \n
\n 5. Start working and earn money! \n
"
  }

  @why_join_as_pro %{
    title: "Why join as a Pro?",
    content:
      "# Why join as a Pro? \n Tired of working for somebody else and/or wasting hours on searching for new clients via your family, friends, LinkedIn or by using online advertising? TaxGig offers you to become your own boss, work when you want and with whom you want. Here is the list of a few other reasons to join: \n
* Forget about local boundaries - prepare tax returns and/or provide bookkeeping for clients located in other states.
* Don't Waste Time on Search - get instantly matched to the client based on your set of skills.
* Earn more - determine your own price for the service.
* Advanced scam protection -  deal only with real people and their needs.
* Intelligent analysis - know how you perform.
* Secure payment system - receive payment protection and guaranties for the work you provide.
* Instant verification - we use open IRS databases and Blockscore to momentarily verify your personal information and credentials.
"
  }

  @who_can_become_pro %{
    title: "Who can become a Pro? What are the minimum requirements?",
    content:
      "# Who can become a Pro? What are the minimum requirements? \n TaxGig primarily deals with tax preparation as well as with other tax related services. Therefore, there is a minimum requirement of holding an active PTIN. If you are a licensed professional, it will give you an advantage over other Pros and will provide an opportunity to apply for our premium feature - TaxGig Hero. Once verified, your credential(-s) will be displayed on your profile. As of now, we exclusively operate in the US. Therefore, only local credentials and verification documents will be accepted. \n
"
  }

  @verification_process %{
    title: "What is the verification process?",
    content:
      "# What is the verification process? \n Clients will be sharing their most private information with you. Therefore, we check your information via the SSA and IRS Directory of PTIN holders by using Blockscore as a third party service and IRS’ open database. Make sure to enter your information correctly to proceed with the registration. **We do not store your SSN**. \n
\n Furthermore, to secure payments and guarantee the payout, we create a Stripe connected account for each Pro. Stripe requires your personal information, such as First Name, Last Name and SSN (last four digits). After successfully passing the verification, the unlimited payouts will be automatically enabled. Make sure to read Stripe’s Terms and Conditions carefully before proceeding. \n
"
  }

  @what_services_can_provide %{
    title: "What services can I provide?",
    content:
      "# What services can I provide? \n TaxGig is a marketplace for tax related services. As of now, we have prepared customized questionnaires for services, such as **Individual Tax Return**, **Business Tax Return**, **Bookkeeping** and **Sales Tax**. Other services, such as Tax Consultation, Quarterly Estimates, Financial Planning and Tax Extension will be enabled in the nearest future. \n
\n If you can provide additional services not listed on the platform, feel free to notify your client and increase the final quote via an Add-On function. \n
"
  }

  @how_matched_with_clients %{
    title: "How do I get matched with clients?",
    content:
      "# How do I get matched with clients? \n TaxGig uses an intelligent algorithm that shows the clients based on the information provided and vice versa. \n
\n First, you need to select what services you provide and identify specific areas and preferences. Then, identify your pricing for the selected fields, as well as for standardized add ons, such as price for additional filing years or states. Other parameters, such as spoken languages, area expertise, your rating and credentials will also affect the matching outcome. \n
"
  }

  @how_much_does_it_cost %{
    title: "How much does it cost?",
    content:
      " # How much does it cost? \n TaxGig is absolutely FREE to join! You can set any price you want for your service and modify it, if needed, when cooperating with the client. TaxGig has a fixed 20% commission fee, which is deducted only when the job is successfully finished. It is used to pay the third party integrations’ fee and improve the performance of the platform. \n
"
  }

  @how_much_can_earn %{
    title: "How much can I earn?",
    content:
      "# How much can I earn? \n TaxGig does not set prices for the services, except when matched automatically as a TaxGig Hero. However, even then you can adjust it via Add ons. If searching for clients manually, just send an offer to your client, which you can still modify later via add ons. TaxGig has a fixed 20% commission fee, which is deducted only when job is successfully finished. It is used to pay the third party integrations’ fee and improve the performance of the platform. \n
"
  }

  @relationship_with_taxgig %{
    title: "What is my relationship with TaxGig?",
    content:
      "# What is my relationship with TaxGig? \n TaxGig does not employ Pros that work on the platform. You are your own boss and regarded as a sole proprietor. However, professional conduct, up to date credentials/PTIN and minimum rating are required to maintain access to the platform and its pool of clients. \n
"
  }

  @my_responsibilities %{
    title: "What are my responsibilities?",
    content:
      "# What are my responsibilities? \n TaxGig expects Pros are obliged to maintain a professional conduct while working with clients, as well as keep their personal information secured and not shared with any third party. Furthermore, make sure to keep your credentials and PTIN up to date with the IRS and their open database, which can be found at PTIN Information and the Freedom of Information Act. Moreover, TaxGig has a minimum requirement of an average 3.5 or above rating based on 5+ jobs to prevent fraud and maintain the high quality service provided via the platform. \n
"
  }

  @how_taxgig_differs_from_other_platforms %{
    title: "How TaxGig differs from other platforms?",
    content:
      "\n Here is the illustration of how TaxGig is superior to other market competitors: \n
\n <img width=100% src='/images/faq/competitive_advantage.png' /> \n"
  }

  @cancelation_policy_pro %{
    title: "Cancelation policy",
    content: "# Cancelation Policy
\n To secure the interaction between clients and Pros and ensure the fairness of the work performed, we have created the following cancellation policy: \n
\n 1. If you cancelled the job in the first 2 hours and your client did not upload any document, there will be no penalty as well as no money received \n
\n 2. If you cancel after the first 2 hours since client went in stage Current Client, you will not receive any money and your client will be able to leave you a rating \n
\n 3. When more than 24 hours have passed since your client went in stage Current Client and/or you have uploaded the Final Document, the cancellation button is disabled. If you have any issues at that point, please contact support@taxgig.com right away. \n
\n 4. If your client cancels the job within the first 2 hours and NOT uploaded any documents, there will be no penalty for any of you and no payout collected. \n
\n 5. If your client cancels the job after 2 passes since he/she went in stage Current Client, he/she will receive a 35% penalty fee that will be paid out to your account. \n
\n 6. If your client cancels the job after you have prepared and uploaded the Final Document, the 75% fee will apply to him/her that will be paid out to your account. However, the client will still be able to leave you a rating. \n
"
  }

  @how_to_accept_payment %{
    title: "How do I accept payments?",
    content:
      "# How do I accept payments? \n Each Pro is automatically created with a Stripe connected account that enables receiving payments and enables a payout to your identified method. Stripe has a scheduled payout once a week. You will be able to see the transaction history and pending balance via your Profile. You are free to add up to 10 payout methods that include Debit cards and/or Bank accounts. When sending an offer to your client or automatically matching via a TaxGig Hero function, you will be asked to select a preferred payout method for the selected job. \n
"
  }

  @how_often_pro_paid %{
    title: "How often do I get paid?",
    content:
      "# How often do I get paid? \n Stripe has a scheduled payout once a week. You will be able to see the transaction history and pending balance via your Profile. You are free to add up to 10 payout methods that include Debit cards and/or Bank accounts. You will be paid out the whole sum after your client goes to the stage Past. If the job is cancelled, the Cancellation policy may apply and only a partial sum will be paid out depending on the stage the incident occurred. Learn more via our Cancelation Policy. \n
"
  }

  @what_is_taxgig_hero %{
    title: "What is a TaxGig Hero?",
    content:
      "# What is a TaxGig Hero? \n TaxGig Hero is a premium function we offer to the best performing Pros. Becoming one will allow you to have more clients and look more professional in the eyes of your potential customers. \n
### Here is the list of perks you automatically get \n
\n * Increased number of open jobs - you can have up to three more clients simultaneously via Instant match. \n
\n * TaxGig Hero badge - let others know that you are the best at your job. \n
\n * Instant match - no more waiting for the response. Now, you will be instantly matched to new clients who match your expertise. Make sure to keep the button ON. \n
# The Deal
\n We will instantly calculate your potential earnings based on the client's answers. You can always use add-ons, if you feel that the price needs to be adjusted. \n
"
  }

  @how_to_become_taxgig_heron %{
    title: "How to become a TaxGig Hero?",
    content:
      "# How to become a TaxGig Hero? \n You have to meet and maintain our requirements. You have to successfully finish 5+ jobs via platform, maintain an average 4.0 rating or higher and have a professional license, such as EA (Enrolled Agent), CPA (Certified Public Accountant) or ATTY (Attorney).  If your license expires, you will have two weeks to update your information. If your rating drops below the required minimum and/or you lose your professional license, TaxGig Hero function will be disabled. You can always restore it when all the requirements are fulfilled again. \n
"
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(FaqCategory)
    Repo.delete_all(Faq)
    Repo.delete_all(PressArticle)
    Repo.delete_all(Vacancy)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_faq_category()
    seed_faq()
    seed_press_article()
    seed_vacancy()
  end

  @spec seed_faq_category() :: nil | Ecto.Schema.t()
  defp seed_faq_category do
    case Repo.aggregate(FaqCategory, :count, :id) > 0 do
      true -> nil
      false -> insert_faq_category()
    end
  end

  @spec seed_faq() :: nil | Ecto.Schema.t()
  defp seed_faq do
    case Repo.aggregate(Faq, :count, :id) > 0 do
      true -> nil
      false -> insert_faq()
    end
  end

  @spec seed_press_article() :: nil | Ecto.Schema.t()
  defp seed_press_article do
    case Repo.aggregate(PressArticle, :count, :id) > 0 do
      true -> nil
      false -> insert_press_article()
    end
  end

  @spec seed_vacancy() :: nil | Ecto.Schema.t()
  defp seed_vacancy do
    case Repo.aggregate(Vacancy, :count, :id) > 0 do
      true -> nil
      false -> insert_vacancy()
    end
  end

  @spec insert_faq_category() :: Ecto.Schema.t()
  defp insert_faq_category do
    [
      Repo.insert!(%FaqCategory{
        title: "General"
      }),
      Repo.insert!(%FaqCategory{
        title: "For Pros"
      })
    ]
  end

  @spec insert_faq() :: Ecto.Schema.t()
  defp insert_faq do
    faq_category_ids = Enum.map(Repo.all(FaqCategory), fn data -> data.id end)

    {ids1, ids2} = {
      Enum.at(faq_category_ids, 0),
      Enum.at(faq_category_ids, 1)
    }

    Landing.create_faq(Map.merge(@what_is_taxgig, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@regular_filer, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@business_owner, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@non_resident_and_expat, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@freelancer_uber_lyft, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@who_are_the_pros, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_it_works, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@is_taxgig_free, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@filing_as_non_resident, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@filing_for_multiple_years, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@state_return, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@multiple_tax_returns_in_progress, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@itemizing_deductions, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@business_tax_returns, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@requesting_services_outside_taxgig, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@contact_my_pro_outside_taxgig, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@choose_same_pro_next_project, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@use_taxgig_outside_the_us, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_taxgig_differs_from_diy, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@when_get_quote, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@pay_upfront, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@client_wants_to_cancel, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@answer_question_incrorrectly, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_quote_generated, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@will_my_quote_change, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@fee_from_refund, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@credit_card_billed_dollar, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_project_routed_to_pro, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@relationship_with_pro, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@if_unhappy_with_service, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_long_is_the_match, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@when_will_complete, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@tax_extention_service, %{faq_category_id: ids1}))
    Landing.create_faq(Map.merge(@how_taxgig_works, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@why_join_as_pro, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@who_can_become_pro, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@verification_process, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@what_services_can_provide, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_matched_with_clients, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_much_does_it_cost, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_much_can_earn, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@relationship_with_taxgig, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@my_responsibilities, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_taxgig_differs_from_other_platforms, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@cancelation_policy_pro, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_to_accept_payment, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_often_pro_paid, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@what_is_taxgig_hero, %{faq_category_id: ids2}))
    Landing.create_faq(Map.merge(@how_to_become_taxgig_heron, %{faq_category_id: ids2}))
  end

  @spec insert_press_article() :: Ecto.Schema.t()
  defp insert_press_article do
    [
      Repo.insert!(%PressArticle{
        author: "Medium",
        img_url: "/images/press/press_article1.svg",
        preview_text:
          "A little after the gig economy successfully started breaking into ordinary citizens’ lives nearly a decade ago, it was obvious that much more routine will be outsourced to independent labor through P2P marketplaces. ",
        title: "TaxGig, an emerging marketplace you should be aware of",
        url:
          "https://medium.com/@taxgig/taxgig-an-emerging-marketplace-you-should-be-aware-of-6011caa7d23"
      })
    ]
  end

  @spec insert_vacancy() :: Ecto.Schema.t()
  defp insert_vacancy do
    Landing.create_vacancy(@marketing_director)
    Landing.create_vacancy(@react_dev)
  end
end
