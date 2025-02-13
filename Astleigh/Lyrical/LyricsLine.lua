LyricsLine = class(Turbine.UI.Label);

function LyricsLine:Constructor(mainwindow, line)
	Turbine.UI.Label.Constructor(self);

	self.mainwindow = mainwindow;
	self.selected = false;

	self:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self:SetForeColor(Turbine.UI.Color(0.8, 0.8, 0.8));
	self:SetMultiline(false);
	self:SetText(line);

	if string.find(line, "%w+") and string.sub(line, 1, 2) ~= "--" and string.sub(line, 1, 1) ~= "%" then
		self.enabled = true;
		self.quickslot = Turbine.UI.Lotro.Quickslot();
		self.quickslot:SetParent(mainwindow);
		self.quickslot:SetSize(38, 38);
		self.quickslot:SetBackColor(Turbine.UI.Color(0.4, 0.3, 0.0));
		--self.quickslot:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, line));
		--workaround for utf8 bug
		--see http://forums.lotro.com/showthread.php?390971-Shortcut-constructor-problems-with-Utf8-characters
		self.shortcut = Turbine.UI.Lotro.Shortcut();
		self.shortcut:SetType(Turbine.UI.Lotro.ShortcutType.Alias);
		self.shortcut:SetData(line);
		self.quickslot:SetShortcut(self.shortcut);
		self.quickslot:SetVisible(false);
		self.quickslot.MouseClick = function(sender, args)
			mainwindow:Advance();
		end
		self.MouseEnter = function(sender, args)
			if not self.selected then
				self:SetForeColor(Turbine.UI.Color(1.0, 1.0, 1.0));
				self:SetOutlineColor(Turbine.UI.Color(0.8, 0.65, 0.1));
				self:SetFontStyle(Turbine.UI.FontStyle.Outline);
			end
		end
		self.MouseLeave = function(sender, args)
			if not self.selected then
				self:SetForeColor(Turbine.UI.Color(0.8, 0.8, 0.8));
				self:SetOutlineColor(Turbine.UI.Color(0.0, 0.0, 0.0));
				self:SetFontStyle(Turbine.UI.FontStyle.None);
			end
		end
	else
		self.enabled = false;
		self:SetForeColor(Turbine.UI.Color(0.4, 0.4, 0.4));
	end
	self:Layout();
end

function LyricsLine:Layout()
	self:SetSize(self.mainwindow:GetWidth() - (20 * 2) - 10, 16);
	if (self.quickslot) then
		self.quickslot:SetPosition((self.mainwindow:GetWidth() / 2) - 20, self.mainwindow:GetHeight() - 38 - 10);
	end
end

function LyricsLine:Destructor()
	self:SetSelected(false);
	self.quickslot = nil;
end

function LyricsLine:SetSelected(val)
	if not self.enabled then
		return;
	end
	if val then
		self.selected = true;
		self:SetOutlineColor(Turbine.UI.Color(0.0, 0.0, 0.0));
		self:SetFontStyle(Turbine.UI.FontStyle.None);
		self:SetBackColor(Turbine.UI.Color(0.8, 0.65, 0.1));
		self:SetForeColor(Turbine.UI.Color(0.0, 0.0, 0.0));
		self.quickslot:SetVisible(true);
	else
		self.selected = false;
		self:SetBackColor(Turbine.UI.Color(0.91, 0.0, 0.0, 0.0));
		self:SetForeColor(Turbine.UI.Color(0.8, 0.8, 0.8));
		self.quickslot:SetVisible(false);
	end
end
