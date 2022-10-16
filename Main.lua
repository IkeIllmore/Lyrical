import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Astleigh.Lyrical";

lyricalVersion = "2.3";

lyricalCommand = Turbine.ShellCommand();

local function out(msg)
	Turbine.Shell.WriteLine(msg);
end

function lyricalCommand:Execute(cmd, args)
	if (args == "show") then
		mainWindow:SetVisible(true);
	elseif (args == "hide") then
		mainWindow:SetVisible(false);
	elseif (args == "toggle") then
		mainWindow:SetVisible(not mainWindow:IsVisible());
	else
		lyricalCommand:GetHelp();
	end
end

function lyricalCommand:GetHelp()
	out("Lyrical v"..lyricalVersion);
	out("  usage: /lyrical [show|hide|toggle]");
	out("  For instructions see the readme file");
end

Turbine.Shell.AddCommand("lyrical", lyricalCommand);

out("Lyrical v"..lyricalVersion.." (/lyrical for more info)");

defaultSettings = {
    version = lyricalVersion,
    position = {left = 100, top = 100}, 
    size = {width = 400, height = 400},
    lyrics = {["1"] = {
        title = "The Fall of Gil-galad",
        path = "",
        text = [[Gil-galad was an Elven-king,
Of him the harpers sadly sing:
The last whose realm was fair and free
Between the mountains and the sea.

His sword was long, his lance was keen.
His shining helm afar was seen.
The countless stars of heaven's field
Were mirrored in his silver shield.

But long ago he rode away,
And where he dwelleth none can say.
For into darkness fell his star;
In Mordor, where the shadows are.]]}},
    page = 1,
    pages = 1};

function saveSettings()
	-- workarounds for savedata in locales that use comma for decimal point
	-- http://forums.lotro.com/showthread.php?365323-Turbine.PluginData.Save-in-german-%28and-french%29-version-of-client
    settings.version = lyricalVersion;
	settings.position.left = string.format("%i", mainWindow:GetLeft());
	settings.position.top = string.format("%i", mainWindow:GetTop());
	settings.size.width = string.format("%i", mainWindow:GetWidth());
	settings.size.height = string.format("%i", mainWindow:GetHeight());
	local saveLyrics = {};
	for i = 1, #mainWindow.lyrics do
		saveLyrics[string.format("%i", i)] = mainWindow.lyrics[i];
	end
	settings.lyrics = saveLyrics;
	settings.page = string.format("%i", mainWindow.page);
	settings.pages = string.format("%i", #mainWindow.lyrics);
	Turbine.PluginData.Save(Turbine.DataScope.Account, "Lyrical", settings);
end

settings = Turbine.PluginData.Load(Turbine.DataScope.Account, "Lyrical") or defaultSettings;

-- don't try to convert pre 1.5 formats
if (settings.version == nil) then
    settings = defaultSettings;
end

-- convert to 2.0 format
if (compareversion(settings.version, "2.0") == 1) then
    for i = 1, settings.pages do
		text = settings.lyrics[string.format("%i", i)];
        lyric = {};
        lyric.text = text;
        lyric.title = "Untitled";
        settings.lyrics[string.format("%i", i)] = lyric;
    end
end

-- convert to 2.1 format
if (compareversion(settings.version, "2.1") == 1) then
    for i = 1, settings.pages do
        settings.lyrics[string.format("%i", i)].path = "";
    end

    settings.version = lyricalVersion;
end

-- convert string indices to numbers
local numericLyrics = {};
for i = 1, settings.pages do
    numericLyrics[i] = settings.lyrics[string.format("%i", i)];
end
settings.lyrics = numericLyrics;


mainWindow = MainWindow();

mainWindow:SetVisible(true);

