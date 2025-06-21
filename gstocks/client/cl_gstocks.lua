gStocks = {}
gStocks.Panel = {}
gStocks.IsPanelOpen = false
gStocks.StockTable = {}

net.Receive("gStocks_SendStocksToPlayer", function()
    local stockString = net.ReadString()
    gStocks.StockTable = util.JSONToTable(stockString)
end)

function gStocks.OpenUI()
    gStocks.Panel = vgui.Create("DFrame")
    gStocks.Panel:SetSize(ScrW() / 2, ScrH() / 2)
    gStocks.Panel:Center()
    gStocks.Panel:SetTitle("")
    gStocks.Panel:SetDraggable(false)
    gStocks.Panel:MakePopup()

    gStocks.Panel.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 180))
    end

    gStocks.StockPanel = vgui.Create("DPanel", gStocks.Panel)
    gStocks.StockPanel:SetWide(ScrW() / 10)
    gStocks.StockPanel:Dock(BOTTOM)
    gStocks.ScrollPanel = vgui.Create("DHorizontalScroller", gStocks.StockPanel)
    gStocks.ScrollPanel:Dock(FILL)
    gStocks.ScrollPanel:SetOverlap(4)

    for symbol, price in pairs(gStocks.StockTable) do
        local thisSymbol, thisPrice = symbol, price

        local button = vgui.Create("DButton")
        button:SetText(thisSymbol)
        button:SetWide(55)
        button.DoClick = function()
            print(thisSymbol, thisPrice)
        end

        gStocks.ScrollPanel:AddPanel(button)
    end
end

function gStocks.OpenPanel()
    if IsValid(gStocks.Panel) then
        gStocks.Panel:Remove()
    end

    gStocks.OpenUI()
end

function gStocks.RequestPrices()
    net.Start("gStocks_GetStockPrices")
    net.SendToServer()
end

net.Receive("gStocks_OpenPanel", function()
    if not gStocks.StockTable or table.IsEmpty(gStocks.StockTable) then
        gStocks.RequestPrices()
    end

    timer.Simple(0.2, function()
        gStocks.OpenPanel()
    end)
end)