INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('STOCK', 'Common stocks and equities traded on public exchanges.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('ETF', 'Exchange Traded Funds — baskets of securities traded like stocks.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BOND', 'Fixed income debt instruments issued by governments or corporations.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('INDEX', 'Market indices tracking a basket of assets e.g. S&P 500, Nasdaq.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MUTUAL_FUND', 'Pooled investment funds managed by a professional fund manager.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MONEY_MARKET', 'Short-term, highly liquid debt instruments e.g. T-bills, commercial paper.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CRYPTO', 'Cryptocurrencies and digital assets e.g. Bitcoin, Ethereum.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CASH', 'Cash and cash equivalents held in the portfolio.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('REIT', 'Real Estate Investment Trusts — companies that own income-producing real estate, traded like stocks.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpassettype (assettype, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('COMMODITY', 'Physical commodities such as gold, silver, oil and agricultural products.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');


INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('NOT_APPLICABLE', 'Industry does not apply to this asset type e.g. bonds, indices, cash. Used as default.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SOFTWARE', 'Software development and technology services e.g. Microsoft, Salesforce.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SEMICONDUCTORS', 'Design and manufacture of semiconductor chips e.g. NVIDIA, Intel, AMD.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('HARDWARE', 'Computer hardware and electronic equipment e.g. Apple, Dell, HP.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RETAIL', 'Consumer retail and e-commerce e.g. Amazon, Walmart, Target.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CONSUMER_STAPLES', 'Essential consumer goods e.g. Procter & Gamble, Coca-Cola, PepsiCo.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('PHARMACEUTICALS', 'Drug development and manufacturing e.g. Pfizer, Johnson & Johnson, Merck.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BIOTECHNOLOGY', 'Biological research and drug discovery e.g. Moderna, Amgen, Gilead.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MEDICAL_DEVICES', 'Medical equipment and devices e.g. Medtronic, Abbott, Boston Scientific.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BANKING', 'Commercial and investment banking e.g. JPMorgan, Bank of America, Wells Fargo.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('INSURANCE', 'Insurance products and services e.g. Berkshire Hathaway, MetLife, AIG.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('ASSET_MANAGEMENT', 'Investment and asset management e.g. BlackRock, Vanguard, Fidelity.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('OIL_GAS', 'Oil and gas exploration, production and refining e.g. ExxonMobil, Chevron.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RENEWABLE_ENERGY', 'Solar, wind and other renewable energy e.g. NextEra Energy, First Solar.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TELECOMMUNICATIONS', 'Telephone and wireless communications e.g. AT&T, Verizon, T-Mobile.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MEDIA', 'Entertainment, streaming and media e.g. Netflix, Disney, Comcast.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('AEROSPACE_DEFENSE', 'Aerospace manufacturing and defense e.g. Boeing, Lockheed Martin, Raytheon.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('AUTOMOTIVE', 'Automobile manufacturing and EV e.g. Tesla, Ford, General Motors, Toyota.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('REAL_ESTATE', 'Real estate development and management e.g. CBRE, Zillow.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('UTILITIES', 'Electric, gas and water utility providers e.g. Duke Energy, Southern Company.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TRANSPORTATION', 'Airlines, shipping and logistics e.g. FedEx, UPS, Delta, Union Pacific.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.lkpindustry (industry, description, enable, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('FOOD_BEVERAGE', 'Food and beverage production e.g. Nestle, Kraft Heinz, Mondelez.', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');


INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('AAPL', 'Apple Inc.', 'Apple', 'STOCK', 'HARDWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TSLA', 'Tesla, Inc.', 'Tesla', 'STOCK', 'AUTOMOTIVE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MSFT', 'Microsoft Corporation', 'Microsoft', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('AMZN', 'Amazon.com, Inc.', 'Amazon', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('NVDA', 'NVIDIA Corporation', 'NVIDIA', 'STOCK', 'SEMICONDUCTORS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('GOOG', 'Alphabet Inc. (Class C)', 'Google', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('GOOGL', 'Alphabet Inc. (Class A)', 'Alphabet', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('META', 'Meta Platforms, Inc.', 'Meta', 'STOCK', 'MEDIA', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('NFLX', 'Netflix, Inc.', 'Netflix', 'STOCK', 'MEDIA', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('ADBE', 'Adobe Inc.', 'Adobe', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('AMD', 'Advanced Micro Devices, Inc.', 'AMD', 'STOCK', 'SEMICONDUCTORS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('INTC', 'Intel Corporation', 'Intel', 'STOCK', 'SEMICONDUCTORS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MU', 'Micron Technology, Inc.', 'Micron', 'STOCK', 'SEMICONDUCTORS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CRM', 'Salesforce, Inc.', 'Salesforce', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('IBM', 'International Business Machines Corporation', 'IBM', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CRWD', 'CrowdStrike Holdings, Inc.', 'CrowdStrike', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('DOCU', 'DocuSign, Inc.', 'DocuSign', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('PATH', 'UiPath Inc.', 'UiPath', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('PLTR', 'Palantir Technologies Inc.', 'Palantir', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TEAM', 'Atlassian Corporation Plc', 'Atlassian', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('VRSN', 'VeriSign, Inc.', 'VeriSign', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BIDU', 'Baidu, Inc.', 'Baidu', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('ZM', 'Zoom Video Communications, Inc.', 'Zoom', 'STOCK', 'SOFTWARE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('WMT', 'Walmart Inc.', 'Walmart', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('COST', 'Costco Wholesale Corporation', 'Costco', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BABA', 'Alibaba Group Holding Limited', 'Alibaba', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('JD', 'JD.com, Inc.', 'JD.com', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('M', 'Macy''s, Inc.', 'Macy''s', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('ABNB', 'Airbnb, Inc.', 'Airbnb', 'STOCK', 'RETAIL', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CVS', 'CVS Health Corporation', 'CVS Health', 'STOCK', 'PHARMACEUTICALS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('PFE', 'Pfizer Inc.', 'Pfizer', 'STOCK', 'PHARMACEUTICALS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MRK', 'Merck & Co., Inc.', 'Merck', 'STOCK', 'PHARMACEUTICALS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('MRNA', 'Moderna, Inc.', 'Moderna', 'STOCK', 'BIOTECHNOLOGY', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TDOC', 'Teladoc Health, Inc.', 'Teladoc', 'STOCK', 'MEDICAL_DEVICES', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('UNH', 'UnitedHealth Group Incorporated', 'UnitedHealth', 'STOCK', 'INSURANCE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BAC', 'Bank of America Corporation', 'Bank of America', 'STOCK', 'BANKING', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('C', 'Citigroup Inc.', 'Citigroup', 'STOCK', 'BANKING', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RKT', 'Rocket Companies, Inc.', 'Rocket Companies', 'STOCK', 'BANKING', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('V', 'Visa Inc.', 'Visa', 'STOCK', 'BANKING', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('HOOD', 'Robinhood Markets, Inc.', 'Robinhood', 'STOCK', 'ASSET_MANAGEMENT', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SOFI', 'SoFi Technologies, Inc.', 'SoFi', 'STOCK', 'ASSET_MANAGEMENT', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BP', 'BP p.l.c.', 'BP', 'STOCK', 'OIL_GAS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('T', 'AT&T Inc.', 'AT&T', 'STOCK', 'TELECOMMUNICATIONS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('VZ', 'Verizon Communications Inc.', 'Verizon', 'STOCK', 'TELECOMMUNICATIONS', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SNAP', 'Snap Inc.', 'Snap', 'STOCK', 'MEDIA', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RBLX', 'Roblox Corporation', 'Roblox', 'STOCK', 'MEDIA', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RDDT', 'Reddit, Inc.', 'Reddit', 'STOCK', 'MEDIA', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('BA', 'The Boeing Company', 'Boeing', 'STOCK', 'AEROSPACE_DEFENSE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RIVN', 'Rivian Automotive, Inc.', 'Rivian', 'STOCK', 'AUTOMOTIVE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('NIO', 'NIO Inc.', 'NIO', 'STOCK', 'AUTOMOTIVE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('LCID', 'Lucid Group, Inc.', 'Lucid Motors', 'STOCK', 'AUTOMOTIVE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('LYFT', 'Lyft, Inc.', 'Lyft', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('UBER', 'Uber Technologies, Inc.', 'Uber', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('DASH', 'DoorDash, Inc.', 'DoorDash', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('DAL', 'Delta Air Lines, Inc.', 'Delta Air Lines', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('UAL', 'United Airlines Holdings, Inc.', 'United Airlines', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('LUV', 'Southwest Airlines Co.', 'Southwest Airlines', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CCL', 'Carnival Corporation & plc', 'Carnival', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('RCL', 'Royal Caribbean Cruises Ltd.', 'Royal Caribbean', 'STOCK', 'TRANSPORTATION', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SBUX', 'Starbucks Corporation', 'Starbucks', 'STOCK', 'FOOD_BEVERAGE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('CAVA', 'Cava Group, Inc.', 'Cava', 'STOCK', 'FOOD_BEVERAGE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SPY', 'SPDR S&P 500 ETF Trust', 'S&P 500 ETF', 'ETF', 'NOT_APPLICABLE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TQQQ', 'ProShares UltraPro QQQ', 'UltraPro QQQ', 'ETF', 'NOT_APPLICABLE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('SQQQ', 'ProShares UltraPro Short QQQ', 'UltraPro Short QQQ', 'ETF', 'NOT_APPLICABLE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TNA', 'Direxion Daily Small Cap Bull 3X Shares', 'Small Cap Bull 3X', 'ETF', 'NOT_APPLICABLE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');

INSERT INTO finance_schema.mstasset (symbol, name, displayname, assettype, industry, market, optionsupported, trackprice, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('TZA', 'Direxion Daily Small Cap Bear 3X Shares', 'Small Cap Bear 3X', 'ETF', 'NOT_APPLICABLE', 'us_market', true, true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');
