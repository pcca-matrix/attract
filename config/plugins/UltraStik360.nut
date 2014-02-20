///////////////////////////////////////////////////
//
// Attract-Mode Frontend - UltraStik360 plugin
//
// For use with the UltraMap (windows) or ultrastikcmd (Linux, OS X) 
// mapping utilities provided by Ultimarc.
//
///////////////////////////////////////////////////

//
// The UserConfig class identifies plugin settings that can be configured
// from Attract-Mode's configuration menu
//
class UserConfig </ help="Integration plug-in for use with the UltraStik360 mapping software provided by Ultimarc: http://www.ultimarc.com" /> {

	</ label="Config Extension", help="The extension of your mapping configuration files", options=".ugc,.um" />
	a_maps_ext=".ugc";

	</ label="Config Directory", help="The directory that contains your mapping configuration files" />
	b_maps_dir="$HOME/UltraMap/Maps/";

	</ label="Default Config Name", help="The name of your default mapping (minus extension)" />
	c_default_map="8 Way";

	</ label="Game Info", help="The game info field that corresponds to the name of your mapping configuration files", options="Name,Control" />
	d_maps_info="Name";
}

local ultra=fe.init_name;
local config=fe.get_config(); // get user config settings corresponding to the UserConfig class above

//
// Copy the configured values from uconfig so we can use them
// whenever the transition callback function gets called
//
local maps_dir = fe.path_expand( config["b_maps_dir"] );

// make sure the directory ends in a slash
if (( maps_dir.len() > 0 ) 
	&& (maps_dir[ maps_dir.len() - 1 ].tointeger() != 47 )  // frontslash
	&& (maps_dir[ maps_dir.len() - 1 ].tointeger() != 92 )) // backslash
{
	maps_dir += "/";
}

local maps_info=Info.Name;
if ( config["d_maps_info"] == "Control" )
	maps_info=Info.Control;

fe.add_transition_callback( "ultra_plugin_transition" );

function ultra_plugin_transition( ttype, var, ttime ) {

	if ( ScreenSaverActive )
		return false;

	switch ( ttype )
	{
	case Transition.ToGame:
		fe.plugin_command( ultra, 
			"\"" + maps_dir 
			+ fe.game_info( maps_info ) 
			+ config["a_maps_ext"] + "\"" );
		break;

	case Transition.FromGame:
		fe.plugin_command( ultra, 
			"\"" + maps_dir 
			+ config["c_default_map"]
			+ config["a_maps_ext"] + "\"" );
		break;
	}

	return false; // must return false
}
