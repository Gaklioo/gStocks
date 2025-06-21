gStocks = gStocks or {}

if CLIENT then
    return 
end

--Max of 30.
gStocks.Stocks = {
    ["MSFT"] = 0,
    ["NVDA"] = 0,
    ["AAPL"] = 0,
    ["AMZN"] = 0,
    ["GOOGL"] = 0,
    ["AMAT"] = 0,
    ["META"] = 0,
    ["AVGO"]= 0,
    ["TSM"] = 0,
    ["NFLX"] = 0,
    ["TSLA"] = 0,
    ["WMT"] = 0,
    ["JPM"] = 0,
    ["LLY"] = 0,
    ["ABNB"] = 0,
    ["V"] = 0
}

--https://finnhub.io/dashboard
gStocks.APIKey = ""
gStocks.StockWebsite = "https://finnhub.io/api/v1/quote?symbol="
gStocks.TimerName = "gStocks_GetStocks"
gStocks.TimerSendName = "gStocks_SendStocks"
gStocks.TimerDelay = 30 -- 30 API calls/ second limit.

timer.Create(gStocks.TimerName, gStocks.TimerDelay, 0, function()
    gStocks.GetPrices()
end)


function gStocks.GetPrices()
    for symbol, _ in pairs(gStocks.Stocks) do
        local url = gStocks.StockWebsite .. symbol .. "&token=" .. gStocks.APIKey

        http.Fetch(url,
            function(body)
                local data = util.JSONToTable(body)
                --[[
                    data.c = price,
                    data.d = change,
                    data.dp = percent change
                    data.h = day high
                    data.l = day low
                    data.o = open
                    data.pc = previous close price
                ]]
                if data and data.c then
                    print(symbol .. ": $" .. data.c)  -- current price
                    gStocks.Stocks[symbol] = data.c
                else
                    print("Failed to get valid data for " .. symbol)
                end
            end,
            function(err)
                print("Error fetching price for " .. symbol .. ": " .. err)
            end
        )
        end
end