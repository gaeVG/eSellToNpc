eSellToNpc = {}

eSellToNpc.Base = {

    Header = {"commonmenu", "interaction_bgd"},
    Color = {color_Green},
    HeaderColor = {255, 255, 255},
    Title = 'Vente de drogue'

}

eSellToNpc.Data = {currentMenu = 'interactions'}

eSellToNpc.Events = {

    onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
        
        startSell(btn.data)

    end

}

eSellToNpc.Menu = {

    ['interactions'] = {

        b = getAllDrugs

    }

}