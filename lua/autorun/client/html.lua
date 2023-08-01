local HTML_CODE = [[

<!DOCTYPE html>

<html>


    <style>

  @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@500&display=swap');

    body {
      text-align: center;
    }



    gamemode {
        --text-color: #6A5ACD;
        color: var(--text-color);
        background-color: rgba(0, 0, 0, 0.75);
        display: block;
        margin: 0 auto;
            width: fit-content;
        text-align: center;
        font-family: 'Ubuntu', sans-serif;
        text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
        font-size: 64px;
    }

        username {
          --hex-color: black; /* Set initial value */
          font-family: 'Ubuntu', sans-serif;
          text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
          font-size: 125px;
          --text-color: var(--default-text-color);
          color: rgb(255,255,255);
          background-color: rgba(0, 0, 0, 0.75);
          display: inline-block;
          position: relative;
          text-align: center;
          white-space: nowrap;
        }

        username::after {
          content: "";
          display: block;
          height: 10px;
          width: 100%;
          background-color: var(--hex-color);
          margin-top: 2px;
        }

    </style>











    <body>

        <gamemode id="gamemode">mode</gamemode>
        <username id="username">name</username>

    </body>

</html>

]]


local players = {}

local function ColorToHex(color)
    local hex = ""
    hex = string.format("%02X", color.r) .. string.format("%02X", color.g) .. string.format("%02X", color.b)
    return hex
end


local function newPlayer(player)

    if not IsValid(player) then return end

    local frame = vgui.Create( "DFrame" )
    --timer.Simple(25,function() 
    --  players[player] = nil
    --  frame:Remove() 
    --end)

    frame:SetTitle( "" )
    frame:SetSize( 2048, 500 )
    frame:SetPos(-1024,0)

    frame:ShowCloseButton(false)
    frame:SetPaintedManually( true )
    frame.Paint = nil

    local dhtml = vgui.Create( 'DHTML', frame )
    dhtml:Dock( FILL )
    dhtml:SetHTML( HTML_CODE )



    local call = "document.getElementById('username').textContent = '"..player:GetName().."';"
    call = call .. "document.getElementById('username').style.setProperty('--hex-color', '#"..  ColorToHex( team.GetColor( player:Team() ) )    .."');"

  local mode = player:GetNWBool("_Kyle_Buildmode")
  if mode then mode = " [ BUILD ] " else 
    mode = " [ PVP ] | HP: "..player:Health()
    call = call .. "document.getElementById('gamemode').style.setProperty('--text-color', '#FFA07A');"
  end

    call = call .. "document.getElementById('gamemode').textContent = '"..mode.."';"


    dhtml:Call( call )



    player.bone_head = player:LookupBone( "ValveBiped.Bip01_Head1" ) or 0
    players[player] = {frame,dhtml}

end


hook.Remove( "PostDrawOpaqueRenderables", "RankOverHead")
hook.Add( "InitPostEntity", "essyrev_nick_over_head", function()


    local me = LocalPlayer()

    for k,v in pairs(player.GetAll()) do
       newPlayer(v)
    end


    gameevent.Listen( "player_spawn" )
    hook.Add( "player_spawn", "player_spawn_example", function( data ) 
        local id = data.userid

        if players[Player(id)] then return end
        timer.Simple(1,function() newPlayer(Player(id)) end)
    end)


    gameevent.Listen( "player_disconnect" )
    hook.Add( "player_disconnect", "essyrev_nick_over_head", function( data )
        local id = data.userid
        players[Player(id)] = nil
    end)

    timer.Create("essyrev_nick_over_head",0.25,0,function()

        for player, frame in pairs(players) do
            if player == me then continue end
            if frame[1] == nil then continue end
            if not IsValid(player) then continue end

            local mode = player:GetNWBool("_Kyle_Buildmode")
            if mode then continue end

            local health = player:Health()
            if (player.last_health or -1) == health then continue end
            player.last_health = health

            local call = ""

        mode = " [ PVP ] | HP: "..player:Health()
        call = call .. "document.getElementById('gamemode').style.setProperty('--text-color', '#FFA07A');"


            call = call .. "document.getElementById('gamemode').textContent = '"..mode.."';"

            frame[2]:Call( call )
        end

    end)


    hook.Add( "PostDrawTranslucentRenderables", "PaintManual Test", function()


        for player, frame in pairs(players) do
            if player == me then continue end
            if frame[1] == nil then continue end
            if not IsValid(player) then continue end

            local angle = (me:GetPos() - player:GetPos()):Angle() or me:EyeAngles()

            cam.Start3D2D((player:GetBonePosition( player.bone_head ) or player:GetPos()) + Vector(0,0,25), Angle(0,angle[2] + 90,90), 0.05)
                frame[1]:PaintManual()
            cam.End3D2D()
        end

    end)
end)
