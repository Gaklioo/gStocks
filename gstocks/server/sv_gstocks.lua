include("gstocks/sh_gstocks.lua")

util.AddNetworkString("gStocks_SendStocksToPlayer")
timer.Create(gStocks.TimerSendName, gStocks.TimerDelay, 0, function()
    print("Sending Table to client")
    local stockTable = util.TableToJSON(gStocks.Stocks)
    net.Start("gStocks_SendStocksToPlayer")
    net.WriteString(stockTable)
    net.Broadcast()
end)

util.AddNetworkString("gStocks_OpenPanel")
hook.Add("PlayerSay", "gStocks_OpenPanel", function(ply, text)
    if string.lower(text) == "/stocks" then
        net.Start("gStocks_OpenPanel")
        net.Send(ply)

        return ""
    end
end)

util.AddNetworkString("gStocks_GetStockPrices")
net.Receive("gStocks_GetStockPrices", function(len, ply)
    print("Sending")
    local stockTable = util.TableToJSON(gStocks.Stocks)
    net.Start("gStocks_SendStocksToPlayer")
    net.WriteString(stockTable)
    net.Send(ply)
end)