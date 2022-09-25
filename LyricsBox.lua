LyricsBox = class(Turbine.UI.ListBox);

function LyricsBox:Constructor(mainwindow)
	Turbine.UI.ListBox.Constructor(self);
	self.mainwindow = mainwindow;
end

function LyricsBox:Layout()
	for i = 1, self:GetItemCount() do
		self:GetItem(i):Layout();
	end
end

function LyricsBox:ClearItems()
	local i = self:GetItemCount();
	while i > 0 do
		self:GetItem(i):SetSelected(false);
		self:RemoveItemAt(i);
		i = i - 1;
	end
end

function LyricsBox:Load(lines)
	local s = 1;
	local e;
	self:ClearItems();
	if lines:len() == 0 then
		return;
	end
	while true do
		e = s;
		while e < lines:len() and lines:sub(e,e) ~= "\n" do
			e = e + 1;
		end
		if e < lines:len() then
			self:AddItem(LyricsLine(self.mainwindow, lines:sub(s, e-1)));
			s = e + 1;
		elseif e == lines:len() then
			self:AddItem(LyricsLine(self.mainwindow, lines:sub(s, e)));
			break;
		end
	end
end

