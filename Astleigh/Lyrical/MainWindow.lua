MainWindow = class(Turbine.UI.Lotro.Window);

function MainWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor(self);

    self.Update = function()
        Plugins["Lyrical"].Unload = saveSettings;
        self:SetWantsUpdates(false);
    end
    self:SetWantsUpdates(true);

	self.line = 1;
	self.editmode = false;
	self.lyrics = settings.lyrics;
	self.page = tonumber(settings.page);
	self:SetPosition(settings.position.left, settings.position.top);
	self:SetSize(settings.size.width, settings.size.height);
	self:SetText("Lyrical");

	-- lyricsbox
	self.lyricsBox = LyricsBox(self);
	self.lyricsBox:SetParent(self);
	self.lyricsBox:SetPosition(30, 45 + 60);
	self.lyricsBox.SelectedIndexChanged = function(sender, args)
		self:Select(self.lyricsBox:GetSelectedIndex());
	end

	-- editbox
	self.editBox = Turbine.UI.Lotro.TextBox();
	self.editBox:SetParent(self);
	self.editBox:SetPosition(30, 45 + 90);
	self.editBox:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.editBox:SetText("");
	self.editBox:SetVisible(false);
	
    -- weird bug: if titleBox is instantiated before editbox,
    -- it breaks scrollBar2
    -- Title
    self.titleText = Turbine.UI.Label();
    self.titleText:SetParent(self);
    self.titleText:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.titleText:SetForeColor(Turbine.UI.Color(0.8, 0.75, 0.5));
    self.titleText:SetPosition(30, 45 + 30);
    self.titleText:SetSize(160, 20);
    self.titleText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.titleText:SetMultiline(false);
    self.titleLabel = Turbine.UI.Label();
    self.titleLabel:SetParent(self);
    self.titleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.titleLabel:SetForeColor(Turbine.UI.Color(0.8, 0.75, 0.5));
    self.titleLabel:SetPosition(30, 45 + 30);
    self.titleLabel:SetSize(60, 20);
    self.titleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.titleLabel:SetText("Title:");
    self.titleLabel:SetVisible(false);
    self.titleBox = Turbine.UI.Lotro.TextBox();
    self.titleBox:SetParent(self);
    self.titleBox:SetFont(Turbine.UI.Lotro.Font.Verdana14);
    self.titleBox:SetPosition(35 + 40, 45 + 30);
    self.titleBox:SetSize(160, 20);
    self.titleBox:SetMultiline(false);
    self.titleBox:SetVisible(false);

    self.pathLabel = Turbine.UI.Label();
    self.pathLabel:SetParent(self);
    self.pathLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.pathLabel:SetForeColor(Turbine.UI.Color(0.8, 0.75, 0.5));
    self.pathLabel:SetPosition(30, 45 + 60);
    self.pathLabel:SetSize(60, 20);
    self.pathLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.pathLabel:SetText("Folder:");
    self.pathLabel:SetVisible(false);
    self.pathBox = Turbine.UI.Lotro.TextBox();
    self.pathBox:SetParent(self);
    self.pathBox:SetFont(Turbine.UI.Lotro.Font.Verdana14);
    self.pathBox:SetPosition(35 + 40, 45 + 60);
    self.pathBox:SetSize(160, 20);
    self.pathBox:SetMultiline(false);
    self.pathBox:SetVisible(false);
    
	-- lyricsbox scrollbar
	self.scrollBar1 = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar1:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar1:SetParent(self);
	self.lyricsBox:SetVerticalScrollBar(self.scrollBar1);

	-- editbox scrollbar
	self.scrollBar2 = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar2:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar2:SetParent(self);
	self.editBox:SetVerticalScrollBar(self.scrollBar2);
	self.scrollBar2:SetVisible(false);

	-- new button
	self.newButton = Turbine.UI.Lotro.Button();
	self.newButton:SetParent(self);
	self.newButton:SetPosition(30, 45);
	self.newButton:SetSize(60, 20);
	self.newButton:SetText("New");
	self.newButton.MouseClick = function(sender, args)
		if self.page == #self.lyrics then
			self.page = self.page + 1;
		else
			for i = #self.lyrics, self.page, -1 do
				self.lyrics[i+1] = self.lyrics[i];
			end
		end
		self.lyrics[self.page] = {};
        self.lyrics[self.page].text = "";
        self.lyrics[self.page].title = "Untitled";
		self:LoadPage(self.page);
        self:SetEditmode(true);
	end

	-- load button
	self.loadButton = Turbine.UI.Lotro.Button();
	self.loadButton:SetParent(self);
	self.loadButton:SetPosition(30 + 60, 45);
	self.loadButton:SetSize(60, 20);
	self.loadButton:SetText("Open");
    self.loadButton.MouseClick = function(sender, args)
        self:BuildMenu():ShowMenu();
    end

	-- edit button
	self.editButton = Turbine.UI.Lotro.Button();
	self.editButton:SetParent(self);
	self.editButton:SetPosition(30 + 120, 45);
	self.editButton:SetSize(60, 20);
	self.editButton:SetText("Edit");
	self.editButton.MouseClick = function(sender, args)
		if not self.editmode then
            self:SetEditmode(true);
		else
            self:SetEditmode(false);
		end
	end

	-- delete button
	self.deleteButton = Turbine.UI.Lotro.Button();
	self.deleteButton:SetParent(self);
	self.deleteButton:SetPosition(30 + 180, 45);
	self.deleteButton:SetSize(60, 20);
	self.deleteButton:SetText("Delete");
	self.deleteButton.MouseClick = function(sender, args)
		if self.page == #self.lyrics then
			self.lyrics[self.page] = nil;
			self.page = self.page - 1;
		else
			for i = self.page, #self.lyrics - 1 do
				self.lyrics[i] = self.lyrics[i+1];
			end
			self.lyrics[#self.lyrics] = nil;
		end
		self:LoadPage(self.page);
	end

	-- resize control
	self.resizeCtrl = Turbine.UI.Control();
	self.resizeCtrl:SetParent(self);
	self.resizeCtrl:SetSize(20, 20);
	self.resizeCtrl:SetPosition(self:GetWidth() - 20, self:GetHeight() - 20);
	self.resizeCtrl.MouseDown = function(sender, args)
		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
	end
	self.resizeCtrl.MouseUp = function(sender, args)
		sender.dragging = false;
	end;
	self.resizeCtrl.MouseMove = function(sender, args)
		local width, height = self:GetSize();
		if (sender.dragging) then
			self:SetSize(width + (args.X - sender.dragStartX),
				height + (args.Y - sender.dragStartY));
			if (self:GetWidth() < 350) then
				self:SetWidth(350);
			end
			if (self:GetHeight() < 138) then
				self:SetHeight(138);
			end
			self:Layout();
		end
		sender:SetPosition(self:GetWidth() - sender:GetWidth(),
			self:GetHeight() - sender:GetHeight());
	end

	self:Layout();
	self:LoadPage(self.page);
end

function MainWindow:Layout()
    self.titleText:SetSize(self:GetWidth() - (30 * 2), 20);
    self.titleBox:SetSize(self:GetWidth() - (30 * 2) - 40, 20);
    self.pathBox:SetSize(self:GetWidth() - (30 * 2) - 40, 20);
	self.lyricsBox:SetSize(self:GetWidth() - (30 * 2), self:GetHeight() - 65 - 45 - 50);

	self.scrollBar1:SetSize(10, self.lyricsBox:GetHeight());
	self.scrollBar1:SetPosition(self.lyricsBox:GetLeft() + self.lyricsBox:GetWidth(), self.lyricsBox:GetTop());
    if (self.editmode) then
        self.scrollBar1:SetVisible(false);
    end

	self.editBox:SetSize(self:GetWidth() - (30 * 2), self:GetHeight() - 65 - 45 - 50);

	self.scrollBar2:SetSize(10, self.editBox:GetHeight());
	self.scrollBar2:SetPosition(self.editBox:GetLeft() + self.editBox:GetWidth(), self.editBox:GetTop());
    if (not self.editmode) then
        self.scrollBar2:SetVisible(false);
    end

	self.lyricsBox:Layout();
end

function MainWindow:Destructor()
	self.lyricsBox:ClearItems();
end

function MainWindow:Select(i)
	if self.lyricsBox:GetItem(i).enabled then
		self.lyricsBox:GetItem(self.line):SetSelected(false);
		self.line = i;
		self.lyricsBox:GetItem(self.line):SetSelected(true);
	end
end

function MainWindow:Advance()
	local i = self.line;
	while true do
		i = i + 1;
		if i > self.lyricsBox:GetItemCount() then
			-- at last line so go back to beginning
			i = 0;
		elseif self.lyricsBox:GetItem(i).enabled then
			-- found a line that is enabled so selected it
			break;
		end
	end
	self:Select(i);
    self.lyricsBox:SetSelectedIndex(i);
end

function MainWindow:Init()
	local i = 1;
	while true do
		if i > self.lyricsBox:GetItemCount() then
			return;
		elseif self.lyricsBox:GetItem(i).enabled then
			break;
		end
		i = i + 1;
	end
	self.line = i;
	self:Select(i);
    self.lyricsBox:SetSelectedIndex(i);
end

function MainWindow:SetEditmode(t)
    if (t) then
			self.editBox:SetText(self.lyrics[self.page].text);
			self.editButton:SetText("Save");
			self.newButton:SetEnabled(false);
            self.loadButton:SetEnabled(false);
			self.deleteButton:SetEnabled(false);
			self.lyricsBox:ClearItems();
			self.lyricsBox:SetVisible(false);
			self.scrollBar1:SetVisible(false);
            self.titleText:SetVisible(false);
            self.titleLabel:SetVisible(true);
            self.titleBox:SetVisible(true);
            self.pathLabel:SetVisible(true);
            self.pathBox:SetVisible(true);
			self.editBox:SetVisible(true);
			self.scrollBar2:SetVisible(true);
			self.editmode = true;
    else
			self.lyrics[self.page].text = self.editBox:GetText();
            self.lyrics[self.page].title = self.titleBox:GetText();
            self.lyrics[self.page].path = self.pathBox:GetText();
			self:LoadPage(self.page);
			self.editButton:SetText("Edit");
			self.newButton:SetEnabled(true);
            self.loadButton:SetEnabled(true);
			self.lyricsBox:SetVisible(true);
			self.scrollBar1:SetVisible(true);
            self.titleText:SetVisible(true);
            self.titleLabel:SetVisible(false);
            self.titleBox:SetVisible(false);
            self.pathLabel:SetVisible(false);
            self.pathBox:SetVisible(false);
			self.editBox:SetVisible(false);
			self.scrollBar2:SetVisible(false);
			self.editmode = false;
            saveSettings();
    end
end

function MainWindow:LoadPage(page)
	self.page = page;
	self.lyricsBox:Load(self.lyrics[self.page].text);
    self.titleBox:SetText(self.lyrics[self.page].title);
    self.pathBox:SetText(self.lyrics[self.page].path);
    self.titleText:SetText(self.lyrics[self.page].title);
	if #self.lyrics == 1 then
		self.deleteButton:SetEnabled(false);
	else
		self.deleteButton:SetEnabled(true);
	end
	self:Init();
end

function MainWindow:BuildMenu()
    local menu = Turbine.UI.ContextMenu();
    local menuItems = menu:GetItems();
    local pathlist = {};
    for i,v in ipairs(self.lyrics) do
        local title = v.title;
        if (title == "") then title = "Untitled" end
        local path = pathsplit(v.path .. "/" .. title);
        pathlist[i] = { path = path, page = i };
    end
    self:MenuWalk(pathlist, menuItems);
    return menu;
end

function pathsplit(s)
	return s:split("/");
end

function MainWindow:MenuWalk(pathlist, parentmenu)
    local pathgroups = groupbypath(pathlist);
    for i,v in ipairs(pathgroups) do
        local item = Turbine.UI.MenuItem(v.head);
        if (v.isleaf) then
            if (v.value.page == self.page) then
                item:SetChecked(true);
            end
            item.Click = function()
                self:LoadPage(v.value.page);
            end
        else
            local subpaths = map(v.value,
                                function(pp)
                                    return { page = pp.page,
                                             path = tail(pp.path) };
                                end);
            self:MenuWalk(subpaths, item:GetItems());
        end
        parentmenu:Add(item);
    end
    return menu;
end

function groupbypath(pagepathlist)
	local output = {};
	local branches = {};
	for i,pagepath in ipairs(pagepathlist) do
		local head = pagepath.path[1];
		local isleaf = #pagepath.path == 1;
		if (isleaf) then
			table.insert(output, { head = head,
                                   isleaf = true,
                                   value = pagepath });
		else
			if (branches[head] == nil) then
                branches[head] = {};
            end
			table.insert(branches[head], pagepath);
		end
	end
	for k,v in pairs(branches) do
		table.insert(output, { head = k,
                               isleaf = false,
                               value = v });
	end
	table.sort(output, function(x, y) return x.head < y.head end);
	return output;
end

