// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default async function handler(req, res) {
  if (req.method == "GET") {
    const baseUrl = {
      data: {
        address: "0xa3fd5dff0b3f5b1799e377110d107ff498064cb7",
        updated_at: "2022-12-04T03:30:28.206298320Z",
        next_update_at: "2022-12-04T03:35:28.206298451Z",
        quote_currency: "USD",
        chain_id: 137,
        items: [
          {
            contract_decimals: 6,
            contract_name: "USD Coin (PoS)",
            contract_ticker_symbol: "USDC",
            contract_address: "0x2791bca1f2de4661ed88a30c99a7a9449aa84174",
            supports_erc: ["erc20"],
            logo_url:
              "https://logos.covalenthq.com/tokens/1/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48.png",
            last_transferred_at: "2022-11-25T06:48:32Z",
            native_token: false,
            type: "cryptocurrency",
            balance: "4455432155485579558",
            balance_24h: "85579558",
            quote_rate: 1.0283517,
            quote_rate_24h: 1.0430057,
            quote: 88.00588,
            quote_24h: 89.259964,
            nft_data: null,
          },
          {
            contract_decimals: 18,
            contract_name: "Matic Token",
            contract_ticker_symbol: "MATIC",
            contract_address: "0x0000000000000000000000000000000000001010",
            supports_erc: ["erc20"],
            logo_url:
              "https://logos.covalenthq.com/tokens/1/0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0.png",
            last_transferred_at: null,
            native_token: true,
            type: "cryptocurrency",
            balance: "999343211098587767",
            balance_24h: "999343211098587767",
            quote_rate: 0.915095,
            quote_rate_24h: 0.9106091,
            quote: 0.9144939,
            quote_24h: 0.91001105,
            nft_data: null,
          },
          {
            contract_decimals: 18,
            contract_name: "Cookie",
            contract_ticker_symbol: "CKIE",
            contract_address: "0x3c0bd2118a5e61c41d2adeebcb8b7567fde1cbaf",
            supports_erc: ["erc20"],
            logo_url:
              "https://logos.covalenthq.com/tokens/137/0x3c0bd2118a5e61c41d2adeebcb8b7567fde1cbaf.png",
            last_transferred_at: "2022-04-29T01:53:21Z",
            native_token: false,
            type: "dust",
            balance: "13901181800000",
            balance_24h: "13901181800000",
            quote_rate: 0.51726174,
            quote_rate_24h: 0.51852024,
            quote: 0.0,
            quote_24h: 7.2080443e-6,
            nft_data: null,
          },
          {
            contract_decimals: 18,
            contract_name: "Wrapped Ether",
            contract_ticker_symbol: "WETH",
            contract_address: "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619",
            supports_erc: ["erc20"],
            logo_url:
              "https://logos.covalenthq.com/tokens/1/0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png",
            last_transferred_at: "2022-11-25T08:48:15Z",
            native_token: false,
            type: "dust",
            balance: "0",
            balance_24h: "0",
            quote_rate: 1251.461,
            quote_rate_24h: 1234.7832,
            quote: 0.0,
            quote_24h: 0.0,
            nft_data: null,
          },
        ],
        pagination: null,
      },
      error: false,
      error_message: null,
      error_code: null,
    };

    try {
      res.status(200).json(baseUrl);
    } catch (e) {
      res.status(500).json({ error: e });
    }
  }
}
