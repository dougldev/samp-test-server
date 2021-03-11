#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <DOF2>

#define COR_VERDE 0x00FF00FF
#define COR_VERMELHA 0xFF0000FF
#define COR_AMARELA 0xFFFF00FF

//	Desenvolvedor Doug

#define function0%(1%) forward 0%(%1); public 0%(%1)

new Float:SpawnMotos[9][4] = {
	{1685.6113, -2299.3767, 13.5272, 180.8490},
	{1682.6487, -2299.3792, 13.5272, 181.8580},
	{1679.8433, -2299.1394, 13.5268, 180.3444},
	{1679.9531, -2296.2283, 13.5249, 178.5426},
	{1682.7946, -2296.0447, 13.5223, 178.1822},
	{1685.5935, -2296.1855, 13.5225, 181.5697},
	{1685.5657, -2293.5945, 13.5187, 180.4166},
	{1682.7273, -2293.1355, 13.5180, 182.0743},
	{1679.9514, -2293.0598, 13.5249, 178.1101}
};

enum pInfo
{
	pAdmin,
	Float:Posx,
	Float:Posy,
	Float:Posz,
	Float:Posr,
	pSkin,
	pDinheiro
}
new DadosPlayer[MAX_PLAYERS][pInfo];

enum // DIALOGS IDS
{
	DIALOG_REGISTRO,
	DIALOG_LOGIN
}

main(){}

public OnGameModeInit()
{
	SetGameModeText("GMD");

	LobbySpawn();

	UsePlayerPedAnims();
 	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	
	return 1;
}

public OnGameModeExit()
{
	DOF2_Exit();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new File[64], String[128];
	format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
	if(!DOF2_FileExists(File))
	{
		format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {FF0000}Nao\n\n{FFFFFF}Digite uma senha para efetuar o registro.", PlayerName(playerid));
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", String, "Registrar", "Sair");
	}
	else
	{
		format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para logar.", PlayerName(playerid));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logar", String, "Logar", "Sair");
	}
	LimparChat(playerid);
	SendClientMessage(playerid, COR_VERDE, "[INFO]: Bem-Vindo ao servidor.");
	InterpolateCameraPos(playerid, 1569.209594, -2317.554931, 21.128261, 1672.632080, -2306.287353, 16.502597, 20000);
	InterpolateCameraLookAt(playerid, 1574.187500, -2317.540527, 20.658813, 1675.290405, -2310.505859, 16.133428, 15000);
	//TogglePlayerSpectating(playerid, true);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new File[64];
	format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
	if(!DOF2_FileExists(File))
	{
		GetPlayerPos(playerid, DadosPlayer[playerid][Posx], DadosPlayer[playerid][Posy], DadosPlayer[playerid][Posz]);
		GetPlayerFacingAngle(playerid, DadosPlayer[playerid][Posr]);

		DOF2_SetInt(File, "Admin", DadosPlayer[playerid][pAdmin]);
		DOF2_SetFloat(File, "PosX", DadosPlayer[playerid][Posx]);
		DOF2_SetFloat(File, "PosY", DadosPlayer[playerid][Posy]);
		DOF2_SetFloat(File, "PosZ", DadosPlayer[playerid][Posz]);
		DOF2_SetFloat(File, "PosR", DadosPlayer[playerid][Posr]);
		DOF2_SetInt(File, "Skin", GetPlayerSkin(playerid));
		DOF2_SetInt(File, "Dinheiro", GetPlayerMoney(playerid));

		DOF2_SaveFile();
	}
	else
	{
		GetPlayerPos(playerid, DadosPlayer[playerid][Posx], DadosPlayer[playerid][Posy], DadosPlayer[playerid][Posz]);
		GetPlayerFacingAngle(playerid, DadosPlayer[playerid][Posr]);

		DOF2_SetInt(File, "Admin", DadosPlayer[playerid][pAdmin]);
		DOF2_SetFloat(File, "PosX", DadosPlayer[playerid][Posx]);
		DOF2_SetFloat(File, "PosY", DadosPlayer[playerid][Posy]);
		DOF2_SetFloat(File, "PosZ", DadosPlayer[playerid][Posz]);
		DOF2_SetFloat(File, "PosR", DadosPlayer[playerid][Posr]);
		DOF2_SetInt(File, "Skin", GetPlayerSkin(playerid));
		DOF2_SetInt(File, "Dinheiro", GetPlayerMoney(playerid));

		DOF2_SaveFile();
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new File[64];
	format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
	if(DOF2_FileExists(File))
	{
		DadosPlayer[playerid][pSkin] = DOF2_GetInt(File, "Skin");
		DadosPlayer[playerid][pDinheiro] = DOF2_GetInt(File, "Dinheiro");
		DadosPlayer[playerid][pAdmin] = DOF2_GetInt(File, "Admin");

		GivePlayerMoney(playerid, DadosPlayer[playerid][pDinheiro]);
		SetPlayerSkin(playerid, DadosPlayer[playerid][pSkin]);
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			new String[250], Float:Pos[3]; GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
			if(strlen(text) > 2 && strlen(text) < 30)
			{
				if(IsPlayerInRangeOfPoint(i, 30.0, Pos[0], Pos[1], Pos[2]))
				{
					if(DadosPlayer[i][pAdmin] > 0)
					{
						format(String, sizeof(String), "{FF0000}[ADMIN]{00FFFF}[{FFFFFF}%d{00FFFF}]{FFFFFF}%s: %s", playerid, PlayerName(playerid), text);
						SendClientMessage(i, -1, String);
					}
					else
					{
						format(String, sizeof(String), "{00FFFF}[{FFFFFF}%d{00FFFF}]{FFFFFF}%s: %s", playerid, PlayerName(playerid), text);
						SendClientMessage(i, -1, String);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000FF, "[ERRO]: Mensagem muito grande ou muito curta.");
			}
		}
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REGISTRO)
	{
		if(!response)
		{
			Kick(playerid);
		}
		else
		{
			new File[64], String[128];
			format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
			if(strlen(inputtext) > 4 && strlen(inputtext) < 15)
			{
				if(!DOF2_FileExists(File))
				{
					DOF2_CreateFile(File);
					DOF2_SetString(File, "Nome", PlayerName(playerid));
					DOF2_SetString(File, "Senha", inputtext);
					DOF2_SaveFile();
				}
				else
				{
					format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para logar.", PlayerName(playerid));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logar", String, "Logar", "Sair");
				}
				SendClientMessage(playerid, COR_VERDE, "[INFO]: Registrado com sucesso em nosso server!");
				SetSpawnInfo(playerid, -1, 26, 1682.9807, -2328.2192, 13.5469, 358.8739, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
			else
			{
				format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {FF0000}Nao\n\n{FF0000}A senha deve conter de 4 a 15 caracteres.", PlayerName(playerid));
				ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", String, "Registrar", "Sair");
			}
		}
	}
	if(dialogid == DIALOG_LOGIN)
	{
		if(!response)
		{
			Kick(playerid);
		}
		else
		{
			new File[64], String[128];
			format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
			if(strlen(inputtext) > 4 && strlen(inputtext) < 15)
			{
				if(strcmp(inputtext, DOF2_GetString(File, "Senha"), true) == 0)
				{
					SendClientMessage(playerid, COR_VERDE, "[INFO]: Voce efetuou o login com sucesso, diverta-se em nosso server!");
					SendClientMessage(playerid, COR_AMARELA, "[AVISO]: Para poder voltar de onde parou utilize: /carregarposicao");
					SetSpawnInfo(playerid, -1, DadosPlayer[playerid][pSkin], 1682.9807, -2328.2192, 13.5469, 358.8739, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
				else
				{
					SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Voce digitou uma senha invalida, tente novamente!");
					format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {00FF00}Sim\n\n{FF0000}Senha incorreta.", PlayerName(playerid));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logar", String, "Logar", "Sair");
				}
			}
			else
			{
				SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Voce digitou uma senha invalida, tente novamente!");
				format(String, sizeof(String), "{00FFFF}Nome: {FFFFFF}%s\n{FFFFFF}Registrado: {00FF00}Sim\n\n{FF0000}Senha incorreta, sua senha deve conter de 4 a 15 caracteres.", PlayerName(playerid));
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logar", String, "Logar", "Sair");
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

stock PlayerName(playerid)
{
	new nome[32];
	GetPlayerName(playerid, nome, sizeof(nome));
	return nome;
}

stock LimparChat(playerid)
{
	for(new i = 0; i < 15; i++)
	{
		SendClientMessage(playerid, -1, " ");
	}
}

stock LobbySpawn()
{
	//		PICKUP PEGAR MOTO.
	for(new i = 0; i < 9; i++)
	{
		CreateVehicle(462, SpawnMotos[i][0], SpawnMotos[i][1], SpawnMotos[i][2], SpawnMotos[i][3], -1, -1, 120);
		CreateDynamic3DTextLabel("{00FFFF}MOTO PUBLICA\n{00FF00}SAINDO DELA VOCE TEM 2 MINUTOS", -1, 1682.6472, -2301.3606, 13.5301, 15.0);
	}
	return 1;
}

CMD:cv(playerid, params[])
{
	if(DadosPlayer[playerid][pAdmin] > 1)
	{
		new String[128], ID, Float:Pos[4], Cor[2]; GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]); GetPlayerFacingAngle(playerid, Pos[3]);
		if(sscanf(params, "ddd", ID, Cor[0], Cor[1])) return SendClientMessage(playerid, 0xFF0000FF, "[ERRO] Digite: /cv [id] [cor1] [cor2].");
		if(ID < 400 && ID > 611) return SendClientMessage(playerid, COR_VERMELHA, "[ERRO] Voce deve utilizar 400 a 611.");
		new carro = CreateVehicle(ID, Pos[0], Pos[1], Pos[2], Pos[3], Cor[0], Cor[1], -1);
		PutPlayerInVehicle(playerid, carro, 0);
		format(String, sizeof(String), "{00FF00}Voce pegou um carro com id %d.", ID);
		SendClientMessage(playerid, -1, String);
	}
	return 1;
}

CMD:carregarposicao(playerid)
{
	new File[64];
	format(File, sizeof(File), "Contas/%s.ini", PlayerName(playerid));
	if(DOF2_FileExists(File))
	{	
		DadosPlayer[playerid][Posx] = DOF2_GetFloat(File, "PosX");
		DadosPlayer[playerid][Posy] = DOF2_GetFloat(File, "PosY");
		DadosPlayer[playerid][Posz] = DOF2_GetFloat(File, "PosZ");
		DadosPlayer[playerid][Posr] = DOF2_GetFloat(File, "PosR");

		SetPlayerPos(playerid, DadosPlayer[playerid][Posx], DadosPlayer[playerid][Posy], DadosPlayer[playerid][Posz]);
		SetPlayerFacingAngle(playerid, DadosPlayer[playerid][Posr]);

		SendClientMessage(playerid, COR_VERDE, "[INFO]: Voce foi para a posicao anterior!");
	}
	else
	{
		return SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Voce tem que desconnectar para ir ate a localizao que estava!");
	}
	return 1;
}

CMD:daradm(playerid, params[])
{
	new ID, NIVEL, String[180];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Voce nao e admin(Rcon).");
	if(sscanf(params, "dd", ID, NIVEL)) return SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Digite: /daradm [id] [nivel].");
	if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Jogador nao esta online.");
	if(NIVEL >= 0 && NIVEL <= 5)
	{
		DadosPlayer[ID][pAdmin] = NIVEL;
		if(DadosPlayer[ID][pAdmin] == 0)
		{
			format(String, sizeof(String), "[INFO]: Voce removeu o admin de %s.", PlayerName(ID));
			SendClientMessage(playerid, COR_AMARELA, String);
			format(String, sizeof(String), "[INFO]: Voce foi removido da staff por: %s", PlayerName(playerid));
			SendClientMessage(playerid, COR_AMARELA, String);
		}
		else
		{
			format(String, sizeof(String), "[INFO]: Voce deu nivel %d de admin para %s.", NIVEL, PlayerName(ID));
			SendClientMessage(playerid, COR_AMARELA, String);
			format(String, sizeof(String), "[INFO]: Voce recebeu admin do %s, nivel de admin %d.", PlayerName(playerid), NIVEL);
			SendClientMessage(playerid, COR_AMARELA, String);
		}
	}
	else
	{
		SendClientMessage(playerid, COR_VERMELHA, "[ERRO]: Niveis de ADM[1 ao 5], digite novamente!");
		return 1;
	}
	return 1;
}