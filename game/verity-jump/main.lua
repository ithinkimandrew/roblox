local function a(b)if game.GameId~=10696604596 then return nil,"unsupported_game"end;b=b or game:GetService("Players").LocalPlayer;if not b then return nil,"player_unavailable"end;local c=b:GetAttribute("WorldId")if c==1 or c==2 or c==3 or c==4 then return c end;return nil,"world_id_unavailable_or_unsupported"end;local d;local e;local function f()local g=e;if not g then return false end;e=nil;if g.connection then g.connection:Disconnect()if g.state then local h=table.find(g.state.connections,g.connection)if h then table.remove(g.state.connections,h)end end end;pcall(function()g.root.Anchored=g.originalAnchored end)g.details.holding=false;return true end;local function i(j,k)k=k or{}local l=d;if l and not l.alive then return nil,"instance_destroyed"end;if l and l.autofarmBusy and l.autofarm and coroutine.running()~=l.autofarm.thread then return nil,"autofarm_owns_movement"end;local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;if k.worldId~=nil and k.worldId~=c then return nil,"target_world_mismatch"end;local n=b:GetAttribute("WorldTravelSequence")local o=b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")local q=o and o:FindFirstChildOfClass("Humanoid")if not p or not q or q.Health<=0 then return nil,"character_not_ready"end;if p.Anchored and not(e and e.root==p)or q.SeatPart then return nil,"character_cannot_move"end;local r=j*o:GetPivot():Inverse()*p.CFrame;local s={targetCFrame=j,position=r.Position,worldId=c,holding=false,groundConfirmed=false,streamSucceeded=false,targetResolved=k.resolveDestination==nil}local function t(u)if s.targetResolved then return false end;local v,w=pcall(k.resolveDestination)if not v or typeof(w)~="CFrame"then return false end;j=w;r=j*o:GetPivot():Inverse()*p.CFrame;s.targetCFrame,s.position=j,r.Position;s.targetResolved=true;if u then o:PivotTo(j)p.AssemblyLinearVelocity=Vector3.zero;p.AssemblyAngularVelocity=Vector3.zero end;return true end;if k.dryRun==true then return true,s end;local x=false;local y=1;local z;z=task.defer(function()s.streamSucceeded=pcall(function()b:RequestStreamAroundAsync(r.Position,y)end)x=true end)if l then table.insert(l.tasks,z)end;local A=l and l.autofarmBusy and l.autofarm;if A then A.teleportStreams[z]=true end;local B=os.clock()+y;repeat task.wait(0.05)until x or os.clock()>=B or l and not l.alive;if not x then pcall(task.cancel,z)end;if A then A.teleportStreams[z]=nil end;if l then local h=table.find(l.tasks,z)if h then table.remove(l.tasks,h)end end;if l and not l.alive then return nil,"instance_destroyed"end;if b.Character~=o or q.Health<=0 then return nil,"character_changed"end;if a(b)~=c or b:GetAttribute("WorldTravelSequence")~=n then return nil,"world_changed"end;t(false)f()local C=p.Anchored;local D=pcall(function()p.Anchored=true;o:PivotTo(j)p.AssemblyLinearVelocity=Vector3.zero;p.AssemblyAngularVelocity=Vector3.zero end)if not D then pcall(function()p.Anchored=C end)return nil,"teleport_failed"end;s.holding=true;local g={root=p,character=o,originalAnchored=C,details=s,state=l}e=g;if l then l.lastTeleport=s end;local E=RaycastParams.new()E.FilterType=Enum.RaycastFilterType.Exclude;E.FilterDescendantsInstances={o}E.RespectCanCollide=true;E.IgnoreWater=true;local F,G,H=0,0,0;g.connection=game:GetService("RunService").Heartbeat:Connect(function(I)if e~=g then return end;if l and not l.alive or b.Character~=o or not p:IsDescendantOf(workspace)or q.Health<=0 or a(b)~=c or b:GetAttribute("WorldTravelSequence")~=n then f()return end;F=F+I;if F<0.1 then return end;H=H+F;F=0;if not s.targetResolved then if H>=0.3 then H=0;t(true)end;if not s.targetResolved then return end;G=0 end;local J=math.max(4,q.HipHeight+p.Size.Y/2+3)local K=workspace:Raycast(p.Position,Vector3.new(0,-J,0),E)local L=K and K.Normal.Y>=0.5 and(K.Instance==workspace.Terrain or K.Instance:IsA("BasePart")and K.Instance.CanCollide)G=L and G+1 or 0;if G>=3 then s.groundConfirmed=true;f()end end)if l then table.insert(l.connections,g.connection)end;return true,s end;local function M(N,k)if typeof(N)~="Vector3"and typeof(N)~="CFrame"then return nil,"invalid_destination"end;k=k or{}if type(k)~="table"then return nil,"invalid_options"end;local O=typeof(N)=="Vector3"and CFrame.new(N)or N;for P,Q in ipairs({O:GetComponents()})do if Q~=Q or math.abs(Q)==math.huge then return nil,"invalid_destination"end end;local b=game:GetService("Players").LocalPlayer;local o=b and b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")if not p then return nil,"character_not_ready"end;return i(O*p.CFrame:Inverse()*o:GetPivot(),k)end;local function R()local b=game:GetService("Players").LocalPlayer;if not b then return nil,"player_unavailable"end;local S=b:GetAttribute("PassWinsX2")if type(S)=="boolean"then return S end;local v,T=pcall(function()return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(b.UserId,1955772279)end)if not v or type(T)~="boolean"then return nil,"wins_pass_status_unavailable"end;return T end;local U,V={},{}local W={}local function X()table.clear(W)if d then d.padsDirty=true end end;local function Y(c,Z)local _=W[c]local a0=c>1 and workspace:FindFirstChild("World"..c)or workspace;if _ and _.root==a0 then return _[Z],_.root end;local T,a1={},{}local p=c>1 and workspace:FindFirstChild("World"..c)or workspace;local function a2(a3)if not a3:IsDescendantOf(workspace)then return false end;local a4=a3;while a4 and a4~=workspace do local a5=tonumber(a4.Name:match("^World(%d+)$"))or a4:GetAttribute("WorldId")if a5~=nil then return a5==c end;a4=a4.Parent end;return c==1 end;local function a6(a3)if not a1[a3]and a2(a3)then a1[a3]=true;table.insert(T,a3)end end;if p then if c>1 then for P,a3 in ipairs(p:GetDescendants())do a6(a3)end else for P,a7 in ipairs(workspace:GetChildren())do if not a7.Name:match("^World%d+$")then a6(a7)if a7.Name=="Main"or a7.Name=="Minecraft"or a7.Name:find("Tower")or a7.Name:find("Pad")or a7.Name:match("^Button%d+$")then for P,a3 in ipairs(a7:GetDescendants())do a6(a3)end end end end end end;for P,a3 in ipairs(game:GetService("CollectionService"):GetTagged(Z))do a6(a3)end;local a8={root=p,WinPad={},StepPad={}}for P,a3 in ipairs(T)do if a3.Name=="WinPad"or a3:GetAttribute("RewardColumn")~=nil then table.insert(a8.WinPad,a3)end;if a3.Name:match("^Button%d+$")or a3.Name:match("^W%d+_Button%d+$")or a3:GetAttribute("SpeedBonus")~=nil then table.insert(a8.StepPad,a3)end end;if p then W[c]=a8 end;return a8[Z],p end;local function a9()local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;local n=b:GetAttribute("WorldTravelSequence")local aa=game:GetService("ReplicatedStorage"):FindFirstChild("Shared")local ab=aa and aa:FindFirstChild("WorldConfig")local ac=aa and aa:FindFirstChild("Config")if not ab or not ac then return nil,"world_config_unavailable"end;local v,ad,ae=pcall(function()return require(ab),require(ac)end)if not v then return nil,"world_config_unavailable"end;if a(b)~=c or b:GetAttribute("WorldTravelSequence")~=n then return nil,"world_changed"end;local af=ad.TowerFor(c)local ag=ad.Get(c)local ah=ag and ag.RUNG_LEVEL or ae.JUMP_RUNG_LEVEL;if type(ah)~="table"then return nil,"world_level_rules_unavailable"end;local ai={}local aj,ak=Y(c,"WinPad")for P,al in ipairs(aj)do local am=al:GetAttribute("WorldId")local an=al:GetAttribute("RewardColumn")local ao=al:GetAttribute("PadType")if al:IsA("BasePart")and(am==c or am==nil)and type(an)=="number"and ah[an]and(ao=="Yellow"or ao=="Purple")then local ap=c==1;for P,aq in ipairs(ag and ag.REWARD_COLUMNS or{})do if an==aq then ap=true;break end end;if ap then table.insert(ai,{pad=al,worldId=c,rewardColumn=an,padType=ao,side=al:GetAttribute("Side"),baseWins=al:GetAttribute("Wins"),requiredLevel=ad.EntryLevel(c)+ah[an]-1})end end end;local ar=U[c]or{}U[c]=ar;local as={}for P,at in ipairs(ai)do local au=at.rewardColumn..":"..at.padType..":"..tostring(at.side)as[au]=true;local av=table.clone(at)av.streamPosition=at.pad.Position;av.pad=nil;ar[au]=av end;for au,at in pairs(ar)do if not as[au]then table.insert(ai,table.clone(at))end end;if ag then for h,an in ipairs(ag.REWARD_COLUMNS)do for P,ao in ipairs({"Yellow","Purple"})do for P,aw in ipairs({"Left","Right"})do local ax=false;for P,at in ipairs(ai)do if at.rewardColumn==an and at.padType==ao and at.side==aw then ax=true;break end end;if not ax then table.insert(ai,{worldId=c,rewardColumn=an,padType=ao,side=aw,baseWins=ag.WIN_REWARDS[h]*(ao=="Purple"and 2 or 1),requiredLevel=ad.EntryLevel(c)+ah[an]-1,streamPosition=ag.OFFSET+Vector3.new(0,ag.TOPS[an],0)})end end end end end;table.sort(ai,function(ay,az)if ay.rewardColumn~=az.rewardColumn then return ay.rewardColumn<az.rewardColumn end;if ay.padType~=az.padType then return ay.padType<az.padType end;return tostring(ay.side)<tostring(az.side)end)return{player=b,worldId=c,sequence=n,tower=af,scope=ak,pads=ai,worldConfig=ad,world=ag,config=ae,cooldown=ae.WIN_PAD_COOLDOWN or 1.5}end;local function aA()local aB,m=a9()if not aB then return nil,m end;return aB.pads end;local aC=-math.huge;local function aD(aq,k)if d and not d.alive then return nil,"instance_destroyed"end;if type(aq)~="number"or aq<1 or aq==math.huge or aq%1~=0 then return nil,"invalid_reward_column"end;k=k or{}if type(k)~="table"then return nil,"invalid_options"end;local ao=k.padType or"Auto"if ao~="Auto"and ao~="Yellow"and ao~="Purple"then return nil,"invalid_pad_type"end;if k.side~=nil and k.side~="Left"and k.side~="Right"then return nil,"invalid_side"end;if k.dryRun~=nil and type(k.dryRun)~="boolean"then return nil,"invalid_dry_run"end;local aB,m=a9()if not aB then return nil,m end;if k.worldId~=nil and k.worldId~=aB.worldId then return nil,"target_world_mismatch"end;local aj={}for P,at in ipairs(aB.pads)do if at.rewardColumn==aq and(k.side==nil or k.side==at.side)then table.insert(aj,at)end end;if#aj==0 then return nil,"pad_not_loaded_in_current_world"end;local aE,aF=R()if aE==nil then return nil,aF end;if ao=="Purple"and not aE then return nil,"double_wins_pass_required"end;if ao=="Auto"then ao=aE and"Purple"or"Yellow"end;local aG;for P,at in ipairs(aj)do if at.padType==ao then aG=at;if at.pad then break end end end;if not aG then return nil,"requested_pad_variant_not_loaded"end;local b=aB.player;local o=b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")local q=o and o:FindFirstChildOfClass("Humanoid")if not p or not p:IsA("BasePart")or not q or q.Health<=0 then return nil,"character_not_ready"end;if p.Anchored and not(e and e.root==p)or q.SeatPart then return nil,"character_cannot_move"end;if b:GetAttribute("CarryingBox")==true then return nil,"carrying_box"end;if os.clock()-aC<aB.cooldown then return nil,"teleport_cooldown"end;if d and not d.alive then return nil,"instance_destroyed"end;if a(b)~=aB.worldId or b:GetAttribute("WorldTravelSequence")~=aB.sequence then return nil,"world_changed"end;local al=aG.pad;local am=al and al:GetAttribute("WorldId")if al and(not al:IsDescendantOf(workspace)or aB.scope and not al:IsDescendantOf(aB.scope)or am~=nil and am~=aB.worldId or al:GetAttribute("RewardColumn")~=aq or al:GetAttribute("PadType")~=ao or k.side~=nil and al:GetAttribute("Side")~=k.side or not al.CanTouch)then return nil,"pad_unavailable"end;local aH=b:GetAttribute("PassWinsX2")if ao=="Purple"and aH==false then return nil,"double_wins_pass_required"end;local aI=q.HipHeight+p.Size.Y/2+0.5;local aJ;if al then aJ=al.CFrame*CFrame.new(0,al.Size.Y/2+aI,0).Position elseif aG.streamPosition then aJ=aG.streamPosition+Vector3.new(0,aI+1,0)else return nil,"pad_position_unavailable"end;local aK=CFrame.new(aJ)*p.CFrame.Rotation;aG.ownsDoubleWinsPass=aE;aG.targetCFrame=aK*p.CFrame:Inverse()*o:GetPivot()aG.dryRun=k.dryRun==true;if aG.dryRun then return true,aG end;local aL=k.side or aG.side;local function aM()local aN=aB.worldConfig.TowerFor(aB.worldId)local aO=aN and aN:FindFirstChild("WinPads")local ak=aB.scope;if not aO and ak and ak~=workspace then aO=ak:FindFirstChild("WinPads",true)end;local aj=aO and aO:GetDescendants()or game:GetService("CollectionService"):GetTagged("WinPad")for P,aP in ipairs(aj)do if aP:IsA("BasePart")and aP:IsDescendantOf(ak or workspace)and(aP:GetAttribute("WorldId")or aB.worldId)==aB.worldId and aP:GetAttribute("RewardColumn")==aq and aP:GetAttribute("PadType")==ao and(not aL or aP:GetAttribute("Side")==aL)then local aQ=aP.CFrame*CFrame.new(0,aP.Size.Y/2+aI,0)return CFrame.new(aQ.Position)*p.CFrame.Rotation*p.CFrame:Inverse()*o:GetPivot()end end end;local D,T=i(aG.targetCFrame,{worldId=aB.worldId,resolveDestination=not al and aM or nil})if not D then return nil,T end;aG.teleport=T;aC=os.clock()return true,aG end;local function aR()local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;local aS=b:FindFirstChild("StepPads")local ai={}for P,aT in ipairs(Y(c,"StepPad"))do local am=aT:GetAttribute("WorldId")local aU=am==c or am==nil;local aV=aT:FindFirstChild("Touch")local aW=aT:GetAttribute("WinCost")local aX=aT:GetAttribute("SpeedBonus")local aY=workspace:FindFirstChild("World"..c)local aZ=c==1 or c>1 and aY and aT:IsDescendantOf(aY)if aU and aZ and aT:IsDescendantOf(workspace)and type(aW)=="number"and type(aX)=="number"then local a_=aS and aS:FindFirstChild(aT.Name)local S=a_~=nil and(not a_:IsA("BoolValue")or a_.Value==true)table.insert(ai,{pad=aT,touch=aV,name=aT.Name,worldId=c,cost=aW,bonus=aX,owned=S,equipped=b:GetAttribute("EquippedStepPad")==aT.Name})end end;local aB=a9()local ag=aB and aB.world;if ag then for b0,aX in ipairs(ag.STEP_BONUSES)do local b1="W"..c.."_Button"..b0;local ax=false;for P,at in ipairs(ai)do if at.name==b1 then ax=true;break end end;if not ax then local a_=aS and aS:FindFirstChild(b1)table.insert(ai,{name=b1,worldId=c,cost=ag.STEP_COSTS[b0],bonus=aX,owned=a_~=nil and(not a_:IsA("BoolValue")or a_.Value),equipped=b:GetAttribute("EquippedStepPad")==b1,streamPosition=ag.OFFSET+Vector3.new(0,10,0)})end end end;local ar=V[c]or{}V[c]=ar;local b2={}for P,at in ipairs(ai)do b2[at.name]=true;local av=table.clone(at)if at.touch then av.streamPosition=at.touch.Position end;if not at.touch and ar[at.name]and ar[at.name].streamPosition then av.streamPosition=ar[at.name].streamPosition;at.streamPosition=av.streamPosition end;av.pad,av.touch=nil,nil;ar[at.name]=av end;for b1,at in pairs(ar)do if not b2[b1]then local av=table.clone(at)local Q=aS and aS:FindFirstChild(b1)av.owned=Q~=nil and(not Q:IsA("BoolValue")or Q.Value==true)av.equipped=b:GetAttribute("EquippedStepPad")==b1;table.insert(ai,av)end end;table.sort(ai,function(ay,az)if ay.bonus~=az.bonus then return ay.bonus<az.bonus end;return ay.name<az.name end)return ai end;local b3=-math.huge;local function b4(b1,k)if d and not d.alive then return nil,"instance_destroyed"end;if type(b1)~="string"then return nil,"invalid_jump_pad"end;k=k or{}if type(k)~="table"then return nil,"invalid_options"end;if k.dryRun~=nil and type(k.dryRun)~="boolean"then return nil,"invalid_dry_run"end;local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;if k.worldId~=nil and k.worldId~=c then return nil,"target_world_mismatch"end;local ai,b5=aR()if not ai then return nil,b5 end;local aG;for P,at in ipairs(ai)do if at.name==b1 then aG=at;break end end;if not aG then return nil,"pad_not_loaded_in_current_world"end;local b6=b:GetAttribute("Wins")if not aG.owned and(type(b6)~="number"or b6~=b6 or b6<aG.cost)then return nil,"insufficient_wins"end;local o=b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")local q=o and o:FindFirstChildOfClass("Humanoid")if not p or not p:IsA("BasePart")or not q or q.Health<=0 then return nil,"character_not_ready"end;if p.Anchored and not(e and e.root==p)or q.SeatPart then return nil,"character_cannot_move"end;if b:GetAttribute("CarryingBox")==true then return nil,"carrying_box"end;if os.clock()-b3<1.5 then return nil,"teleport_cooldown"end;if a(b)~=c then return nil,"world_changed"end;local aV=aG.touch;if aV and(not aV:IsDescendantOf(workspace)or not aV.CanTouch)then return nil,"pad_unavailable"end;local aI=q.HipHeight+p.Size.Y/2+0.5;local aJ;if aV then aJ=aV.CFrame*CFrame.new(0,aV.Size.Y/2+aI,0).Position elseif aG.streamPosition then aJ=aG.streamPosition+Vector3.new(0,aI+1,0)else return nil,"pad_position_unavailable"end;aG.targetCFrame=CFrame.new(aJ)*p.CFrame.Rotation*p.CFrame:Inverse()*o:GetPivot()aG.dryRun=k.dryRun==true;if aG.dryRun then return true,aG end;local function b7()local ak=c==1 and workspace or workspace:FindFirstChild("World"..c)local aT=ak and ak:FindFirstChild(b1,true)local aP=aT and aT:FindFirstChild("Touch")if aP and aP:IsA("BasePart")then local aQ=aP.CFrame*CFrame.new(0,aP.Size.Y/2+aI,0)return CFrame.new(aQ.Position)*p.CFrame.Rotation*p.CFrame:Inverse()*o:GetPivot()end end;local D,T=i(aG.targetCFrame,{worldId=c,resolveDestination=not aV and b7 or nil})if not D then return nil,T end;aG.teleport=T;b3=os.clock()return true,aG end;local function b8()local l=d;if not l or not l.alive or not workspace.StreamingEnabled then return end;local b=game:GetService("Players").LocalPlayer;local b9=a(b)if not b9 then return end;local ba=b9 ..":"..tostring(b:GetAttribute("WorldTravelSequence"))if l.streamKey==ba then return end;local aB=a9()if not aB then return end;local au=aB.worldId..":"..tostring(aB.sequence)if l.streamKey==au then return end;l.streamKey=au;local bb;bb=task.defer(function()local ag=aB.world;local bc=ag and ag.OFFSET or Vector3.zero;local bd={bc+Vector3.new(0,10,0)}for P,be in ipairs(ag and ag.TIER_TOPS or aB.config.HEIGHT_TIER_TOPS or{})do table.insert(bd,bc+Vector3.new(0,be,0))end;for P,aJ in ipairs(bd)do if not l.alive or a(aB.player)~=aB.worldId or aB.player:GetAttribute("WorldTravelSequence")~=aB.sequence then break end;pcall(function()aB.player:RequestStreamAroundAsync(aJ,1)end)if not l.alive then break end;a9()aR()l.padsDirty=true end;local h=table.find(l.tasks,bb)if h then table.remove(l.tasks,h)end end)table.insert(l.tasks,bb)end;local function bf()local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;local bg={Gold="PassGoldBed",Diamond="PassDiamondBed",Obsidian="PassObsidianBed"}local function bh(b0)return b0=="Red"or b0=="Emerald"and b:GetAttribute("GroupReward")==true or bg[b0]~=nil and b:GetAttribute(bg[b0])==true end;local bi,b2={},{}for P,bj in ipairs(game:GetService("CollectionService"):GetTagged("BounceBed"))do local b0=bj:GetAttribute("BedTier")if bj:IsA("BasePart")and bj:IsDescendantOf(workspace)and(bj:GetAttribute("WorldId")or 1)==c and bh(b0)then table.insert(bi,{tier=b0,bed=bj,worldId=c,multiplier=bj:GetAttribute("LevelMultiplier")})b2[b0]=true end end;for P,b0 in ipairs({"Red","Emerald","Gold","Diamond","Obsidian"})do if bh(b0)and not b2[b0]then table.insert(bi,{tier=b0,worldId=c})end end;local bk={Red=1,Emerald=2,Gold=3,Diamond=4,Obsidian=5}table.sort(bi,function(ay,az)return bk[ay.tier]<bk[az.tier]end)return bi end;local bl=-math.huge;local function bm(b0,k)if d and not d.alive then return nil,"instance_destroyed"end;k=k or{}if type(k)~="table"then return nil,"invalid_options"end;local b=game:GetService("Players").LocalPlayer;local c,m=a(b)if not c then return nil,m end;if k.worldId~=nil and k.worldId~=c then return nil,"target_world_mismatch"end;local n=b:GetAttribute("WorldTravelSequence")local function bn()for P,at in ipairs(bf()or{})do if at.tier==b0 then return at end end end;local aG=bn()if not aG then return nil,"bed_not_owned"end;if not aG.bed then pcall(function()b:RequestStreamAroundAsync(Vector3.new(0,10,(c-1)*5000),2)end)aG=bn()end;if d and not d.alive then return nil,"instance_destroyed"end;if a(b)~=c or b:GetAttribute("WorldTravelSequence")~=n then return nil,"world_changed"end;if not aG then return nil,"bed_not_owned"end;if not aG.bed or not aG.bed:IsDescendantOf(workspace)then return nil,"bed_streaming_retry_in_a_moment"end;local o=b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")local q=o and o:FindFirstChildOfClass("Humanoid")if not p or not q or q.Health<=0 then return nil,"character_not_ready"end;if p.Anchored and not(e and e.root==p)or q.SeatPart then return nil,"character_cannot_move"end;if b:GetAttribute("CarryingBox")==true then return nil,"carrying_box"end;if os.clock()-bl<1.5 then return nil,"teleport_cooldown"end;local aI=aG.bed.Size.Y/2+q.HipHeight+p.Size.Y/2+0.5;local aJ=aG.bed.CFrame*CFrame.new(0,aI,0).Position;aG.targetCFrame=CFrame.new(aJ)*p.CFrame.Rotation*p.CFrame:Inverse()*o:GetPivot()if k.dryRun==true then return true,aG end;local v,T=i(aG.targetCFrame,{worldId=c})if not v then return nil,T end;aG.teleport=T;bl=os.clock()return true,aG end;local bo={detectWorld=a,hasDoubleWinsPass=R,getWinPads=aA,teleportToWinPad=aD,getJumpPads=aR,teleportToJumpPad=b4,getOwnedBeds=bf,teleportToBed=bm,teleportToPosition=M,cancelTeleportHold=f}local bp=type(getgenv)=="function"and getgenv()or _G;local bq="__VerityJumpTower2"local br=bp[bq]if type(br)=="table"and type(br.Destroy)=="function"then local v,m=pcall(br.Destroy,br)if not v then error("Previous instance cleanup failed: "..tostring(m))end end;local l={alive=true,connections={},tasks={},api=bo}d=l;bp[bq]=l;local bs=game:GetService("UserInputService")l.originalMouseIconEnabled=bs.MouseIconEnabled;local function bt(bu)if not bu then return end;if type(bu.Destroy)=="function"then bu:Destroy()return end;bu.loaded=false;for P,bv in pairs(bu.connections or{})do pcall(function()bv:Disconnect()end)end;for P,bw in pairs(bu.drawings or{})do for P,bx in pairs(bw)do pcall(function()bx[1]:Remove()end)end;table.clear(bw)end;table.clear(bu.connections or{})end;function l:Destroy()if not self.alive then return end;self.alive=false;if self.autofarm then self.autofarm:Destroy()end;if self.movement then self.movement:Destroy()end;if self.boxPrompt then pcall(function()self.boxPrompt:InputHoldEnd()end)self.boxPrompt=nil end;f()for P,bv in ipairs(self.connections)do pcall(function()bv:Disconnect()end)end;table.clear(self.connections)for P,bb in ipairs(self.tasks)do if bb~=coroutine.running()then pcall(task.cancel,bb)end end;table.clear(self.tasks)if self.idleMouseDown and self.idleInputManager then pcall(function()self.idleInputManager:SendMouseButtonEvent(0,0,0,false,game,0)end)self.idleMouseDown=false end;bt(self.library)bs.MouseIconEnabled=self.originalMouseIconEnabled;self.window=nil;self.ui=nil;if bp[bq]==self then bp[bq]=nil end end;bo.Destroy=function()l:Destroy()end;local by={alive=true,values={},baseline={},connections={},maskedReads=0}l.movement=by;local bz=game:GetService("Players").LocalPlayer;local bA={"WalkSpeed","JumpPower","JumpHeight","UseJumpPower"}local function bB(q,au)if by.originalIndex then return by.originalIndex(q,au)end;return q[au]end;local function bC()local bD=by.humanoid;if not l.alive or not bD or not bD.Parent or by.applying then return end;by.applying=true;local v,bE=pcall(function()if by.values.walkSpeed~=nil then bD.WalkSpeed=by.values.walkSpeed end;if by.values.jumpPower~=nil then bD.UseJumpPower=true;bD.JumpPower=by.values.jumpPower end end)by.applying=false;if not v then by.lastError=tostring(bE)end end;function by:Reset()self.values={}local bD=self.humanoid;if bD and bD.Parent then self.applying=true;for P,au in ipairs(bA)do if self.baseline[au]~=nil then pcall(function()bD[au]=self.baseline[au]end)end end;self.applying=false end end;function by:Destroy()self.alive=false;for P,bv in ipairs(self.connections)do bv:Disconnect()end;table.clear(self.connections)self:Reset()if self.hook then self.hookRestored=pcall(hookmetamethod,game,"__index",self.originalIndex)end end;local function bF(q)for P,bv in ipairs(by.connections)do bv:Disconnect()end;table.clear(by.connections)if by.humanoid and by.humanoid~=q then local bG=by.values;by:Reset()by.values=bG end;by.humanoid=q;by.baseline={}for P,au in ipairs(bA)do by.baseline[au]=bB(q,au)end;table.insert(by.connections,q.Changed:Connect(function(au)if not l.alive or by.applying or by.humanoid~=q then return end;local bH=au=="WalkSpeed"and by.values.walkSpeed~=nil or(au=="JumpPower"or au=="UseJumpPower")and by.values.jumpPower~=nil;if table.find(bA,au)then local bI=bB(q,au)local bJ=au=="WalkSpeed"and by.values.walkSpeed or au=="JumpPower"and by.values.jumpPower or au=="UseJumpPower"and by.values.jumpPower~=nil and true;if not bH or bI~=bJ then by.baseline[au]=bI end;if bH and bI~=bJ then bC()end end end))bC()end;if type(hookmetamethod)=="function"and type(checkcaller)=="function"and type(newcclosure)=="function"then local bK=newcclosure(function(a3,au)if by.alive and l.alive and a3==by.humanoid and not checkcaller()then local bL=au=="WalkSpeed"and by.values.walkSpeed~=nil or(au=="JumpPower"or au=="JumpHeight"or au=="UseJumpPower")and by.values.jumpPower~=nil;if bL and by.baseline[au]~=nil then by.maskedReads=by.maskedReads+1;return by.baseline[au]end end;return by.originalIndex(a3,au)end)local v,bM=pcall(hookmetamethod,game,"__index",bK)if v then by.originalIndex,by.hook=bM,bK;if type(getrawmetatable)=="function"then local bN,bO=pcall(getrawmetatable,game)if bN then by.installedIndex=bO.__index end end else by.lastError=tostring(bM)end end;local bP=bz.Character;local bQ=bP and bP:FindFirstChildOfClass("Humanoid")if bQ then bF(bQ)end;table.insert(l.connections,bz.CharacterAdded:Connect(function(o)local bb;bb=task.defer(function()local bD=o:WaitForChild("Humanoid",8)if l.alive and bz.Character==o and bD then bF(bD)end;local h=table.find(l.tasks,bb)if h then table.remove(l.tasks,h)end end)table.insert(l.tasks,bb)end))bo.setPlayerMovement=function(bG)if not l.alive then return nil,"instance_destroyed"end;if l.autofarmBusy then return nil,"autofarm_owns_movement"end;if type(bG)~="table"then return nil,"invalid_movement_values"end;for au,Q in pairs(bG)do local bR=au=="walkSpeed"and 500 or au=="jumpPower"and 1000;if not bR or type(Q)~="number"or Q~=Q or Q<0 or Q>bR then return nil,"invalid_"..tostring(au)end end;if not by.humanoid or not by.humanoid.Parent then return nil,"character_not_ready"end;for au,Q in pairs(bG)do by.values[au]=Q end;bC()return true end;bo.resetPlayerMovement=function()if not l.alive then return nil,"instance_destroyed"end;if l.autofarmBusy then return nil,"autofarm_owns_movement"end;by:Reset()return true end;bo.getPlayerMovement=function()local bD=by.humanoid;if not l.alive or not bD or not bD.Parent then return nil,"character_not_ready"end;local bI={}for P,au in ipairs(bA)do bI[au]=bB(bD,au)end;bI.suggestedPower=by.values.jumpPower or(bI.UseJumpPower and bI.JumpPower or math.sqrt(2*workspace.Gravity*math.max(0,bI.JumpHeight)))return bI end;local function bS(bT,k)if not l.alive then return nil,"instance_destroyed"end;bT=bT==true;if bT and l.autofarm and l.autofarm.enabled then l.autofarm:Stop("Box capture enabled")end;if bT and l.boxCaptureEnabled then return true end;l.boxCaptureEnabled=bT;l.boxCaptureGeneration=(l.boxCaptureGeneration or 0)+1;local bU=l.boxCaptureGeneration;l.boxCaptureOnce=bT and type(k)=="table"and k.once==true;if l.boxTeleport and e and e.details==l.boxTeleport then f()end;l.boxTeleport=nil;if l.boxPrompt then pcall(function()l.boxPrompt:InputHoldEnd()end)l.boxPrompt=nil end;if l.boxCaptureThread then if l.boxCaptureThread~=coroutine.running()then pcall(task.cancel,l.boxCaptureThread)end;local h=table.find(l.tasks,l.boxCaptureThread)if h then table.remove(l.tasks,h)end;l.boxCaptureThread=nil end;l.boxCaptureStatus=bT and"Finding boxes"or"Stopped"if not bT then return true end;f()l.boxCaptureCollected=l.boxCaptureCollected or 0;local b=game:GetService("Players").LocalPlayer;local ad=require(game:GetService("ReplicatedStorage").Shared.WorldConfig)local bV=setmetatable({},{__mode="k"})local bW=-math.huge;local function bX()if l.boxPrompt then pcall(function()l.boxPrompt:InputHoldEnd()end)l.boxPrompt=nil end end;local bb=task.defer(function()while l.alive and l.boxCaptureEnabled and l.boxCaptureGeneration==bU do local v,bY=pcall(function()local ag=a(b)local o=b.Character;local p=o and o:FindFirstChild("HumanoidRootPart")local q=o and o:FindFirstChildOfClass("Humanoid")if not ag or b:GetAttribute("WorldChanging")==true or not p or not q or q.Health<=0 then l.boxCaptureStatus="Waiting for character/world"return end;if p.Anchored or q.SeatPart or b:GetAttribute("BoxOpening")==true then l.boxCaptureStatus="Waiting for movable character"return end;local n=b:GetAttribute("WorldTravelSequence")local function bZ()return l.alive and l.boxCaptureEnabled and l.boxCaptureGeneration==bU and b.Character==o and q.Health>0 and a(b)==ag and b:GetAttribute("WorldTravelSequence")==n and b:GetAttribute("WorldChanging")~=true end;local function b_(c0,c1)local B=os.clock()+c0;repeat if not bZ()then return false end;if c1 and c1()then return true end;task.wait(0.05)until os.clock()>=B;return bZ()and(not c1 or c1())end;local function u(O)if not bZ()then return false end;o:PivotTo(O*p.CFrame:Inverse()*o:GetPivot())p.AssemblyLinearVelocity,p.AssemblyAngularVelocity=Vector3.zero,Vector3.zero;return true end;local c2=ad.AssetsFor(ag)local ak=ag==1 and workspace:FindFirstChild("Main")or c2;local c3=ak and ak:FindFirstChild("SpawnLocation",true)if ag==1 and not c3 then for P,a7 in ipairs(workspace:GetChildren())do if not a7.Name:match("^World%d+$")and not c3 then c3=a7:IsA("SpawnLocation")and a7 or a7:FindFirstChild("SpawnLocation",true)end end end;if not c3 or not c3:IsA("BasePart")then l.boxCaptureStatus="Loading world surface"if os.clock()-bW>=8 then bW=os.clock()pcall(function()b:RequestStreamAroundAsync(ad.OffsetFor(ag)+Vector3.new(138,3,156),1)end)end;return end;local c4=CFrame.new(c3.Position+Vector3.new(0,0.3,0))*p.CFrame.Rotation;local c5,c6=c3.Position.X-58.5,c3.Position.Z;local function c7(aT,aP)local aQ=aP and aP.CFrame or aT:GetPivot()local c8=c6-aQ.Position.Z;local bc=math.abs(c8)>1 and Vector3.new(0,2,c8>0 and 4 or-4)or Vector3.new(2,2,0)return CFrame.new(aQ.Position+bc)*p.CFrame.Rotation end;local aO=workspace:FindFirstChild("TowerBoxes")local aG,c9,ca,cb;if b:GetAttribute("CarryingBox")~=true then local cc=require(game:GetService("ReplicatedStorage").Shared.BoxConfig).InventoryLimit;if(b:GetAttribute("BoxCount")or 0)>=cc then l.boxCaptureStatus="Box inventory full"return end;for P,aT in ipairs(aO and aO:GetChildren()or{})do if aT:IsA("Model")and aT:GetAttribute("BoxWorld")==ag and not aT:GetAttribute("HolderUserId")and(bV[aT]or 0)<=os.clock()then local cd=aT:FindFirstChild("PickUpBox",true)local aP=cd and cd.Parent;if not cd or cd:IsA("ProximityPrompt")and cd.Enabled and aP:IsA("BasePart")then local ce=aT:GetAttribute("BoxRarity")or 0;local aJ=aP and aP.Position or aT:GetPivot().Position;local cf=p.Position-aJ.Magnitude;if(not l.boxCaptureRank or ce==l.boxCaptureRank)and(not ca or ce>ca or ce==ca and cf<cb)then aG,c9,ca,cb=aT,cd,ce,cf end end end end;if not aG then l.boxCaptureStatus="Waiting for world box spawns"return end end;local cg=b:GetAttribute("BoxCount")or 0;local ch=l.boxCollectSequence or 0;local function ci()return(b:GetAttribute("BoxCount")or 0)>cg or(l.boxCollectSequence or 0)>ch end;if aG then l.boxCaptureLastAttempt={box=aG.Name,world=ag,startedAt=os.clock()}l.boxCaptureStatus="Loading "..aG.Name;local O=c7(aG,c9 and c9.Parent)local D,s=M(O,{worldId=ag})if not D then l.boxCaptureStatus=tostring(s)return end;l.boxTeleport=s;b_(5,function()c9=aG:FindFirstChild("PickUpBox",true)return c9~=nil and s.groundConfirmed end)if e and e.details==s then f()end;l.boxTeleport=nil;if not bZ()then return end;if not c9 or not s.groundConfirmed then bV[aG]=os.clock()+15;l.boxCaptureStatus="Waiting for box platform to load"return end end;if c9 then l.boxCaptureStatus="Picking up "..c9.ObjectText;if not u(c7(aG,c9.Parent))then return end;if not b_(0.35)then return end;if p.Position-c9.Parent.Position.Magnitude>c9.MaxActivationDistance then bV[aG]=os.clock()+15;l.boxCaptureStatus="Box arrival reset; retrying"return end;for P=1,2 do if not bZ()or not c9:IsDescendantOf(workspace)or not c9.Enabled then break end;if p.Position-c9.Parent.Position.Magnitude>c9.MaxActivationDistance then break end;l.boxPrompt=c9;c9:InputHoldBegin()b_(c9.HoldDuration+0.25,function()return b:GetAttribute("CarryingBox")==true end)bX()if b:GetAttribute("CarryingBox")==true then break end;if not b_(0.3)then return end end;if not bZ()then return end;if b:GetAttribute("CarryingBox")~=true then bV[aG]=os.clock()+15;l.boxCaptureStatus="Pickup unconfirmed; skipping"return end;l.boxCaptureLastAttempt.pickedUpAt=os.clock()l.boxCaptureStatus="Confirming pickup (0.3s)"local cj=os.clock()+0.3;repeat if not bZ()then return end;if b:GetAttribute("CarryingBox")~=true or aG:GetAttribute("HolderUserId")~=b.UserId then bV[aG]=os.clock()+15;l.boxCaptureLastAttempt.result="lost_during_confirmation"l.boxCaptureStatus="Pickup did not stay confirmed"return end;task.wait(0.05)until os.clock()>=cj;l.boxCaptureLastAttempt.confirmedAt=os.clock()end;local function ck(N,cl)l.boxCaptureStatus=cl;local cm=p.Position;local cf=N-cm.Magnitude;if cf<0.1 then return true end;local cn=0;while cn<cf do if not bZ()then return false end;if ci()then return true end;if b:GetAttribute("CarryingBox")~=true then return false end;local co=game:GetService("RunService").Heartbeat:Wait()if not bZ()then return false end;if ci()then return true end;if b:GetAttribute("CarryingBox")~=true then return false end;cn=math.min(cf,cn+math.min(20,600*co))if not u(CFrame.new(cm:Lerp(N,cn/cf))*c4.Rotation)then return false end end;return true end;local cp=ck(Vector3.new(c5,p.Position.Y,c6),"Moving to clear descent lane")if cp and not ci()then cp=ck(Vector3.new(c5,c3.Position.Y+3.3,c6),"Descending with box")end;if cp and not ci()then cp=ck(c4.Position,"Delivering box")end;local cq=ci()or cp and b_(2,ci)if not bZ()then return end;if cq then l.boxCaptureCollected=l.boxCaptureCollected+1;if l.boxCaptureLastAttempt then l.boxCaptureLastAttempt.result="collected"l.boxCaptureLastAttempt.finishedAt=os.clock()end;l.boxCaptureStatus="Box captured"if l.boxCaptureOnce then bS(false)l.boxCaptureStatus="Box captured"end else if aG then bV[aG]=os.clock()+15 end;if l.boxCaptureLastAttempt then l.boxCaptureLastAttempt.result=b:GetAttribute("CarryingBox")==true and"delivery_unconfirmed"or"dropped"l.boxCaptureLastAttempt.finishedAt=os.clock()end;l.boxCaptureStatus=b:GetAttribute("CarryingBox")==true and"Delivery unconfirmed; retrying surface"or"Box lost; retrying"end end)bX()if not v then l.boxCaptureStatus="Retrying: "..tostring(bY)end;task.wait(1)end end)l.boxCaptureThread=bb;table.insert(l.tasks,bb)return true end;bo.setBoxCapture=bS;bo.setBoxCaptureSelection=function(b1)if not l.alive then return nil,"instance_destroyed"end;if b1==nil or b1=="Auto (highest rarity)"then l.boxCaptureRank=nil;return true end;for ce,b0 in ipairs(require(game:GetService("ReplicatedStorage").Shared.BoxConfig).Tiers)do if b0.Name==b1 and not b0.ShopOnly then l.boxCaptureRank=ce;return true end end;return nil,"unknown_box_type"end;local cr=game:GetService("ReplicatedStorage"):FindFirstChild("BoxRemotes")local cs=cr and cr:FindFirstChild("Effect")if cs then table.insert(l.connections,cs.OnClientEvent:Connect(function(ct,cu)if ct=="Collect"and cu==game:GetService("Players").LocalPlayer.UserId then l.boxCollectSequence=(l.boxCollectSequence or 0)+1 end end))end;local function cv(ai,aX,b6)local aG;for P,at in ipairs(ai or{})do if at.bonus>aX and(at.owned or b6>=at.cost)and(not aG or at.bonus>aG.bonus)then aG=at end end;return aG end;local function cw()if l.padAutoThread then return end;local bb;bb=task.defer(function()while l.alive and(l.autoWinPads or l.autoJumpUpgrade)do local v,bE=pcall(function()local b=game:GetService("Players").LocalPlayer;local ag=a(b)if not ag or b:GetAttribute("WorldChanging")==true then return end;if l.boxCaptureEnabled or b:GetAttribute("CarryingBox")==true then return end;if e then return end;if l.autoJumpUpgrade then local cx=cv(aR(),b:GetAttribute("StepBonus")or 0,b:GetAttribute("Wins")or 0)if cx then local cy,cz=b4(cx.name,{worldId=ag})if cy then l.padAutoTeleport=cz.teleport end;l.padAutoStatus=cy and"Upgrading: "..cx.name or tostring(cz)return end end;if l.autoWinPads and l.readAutoWinOptions then local an,k=l.readAutoWinOptions()if an then local cy,cz=aD(an,k)if cy then l.padAutoTeleport=cz.teleport end;l.padAutoStatus=cy and"Auto wins: column "..an or tostring(cz)end end end)if not v then l.padAutoStatus=tostring(bE)end;task.wait(3)end;l.padAutoThread=nil;local h=table.find(l.tasks,bb)if h then table.remove(l.tasks,h)end end)l.padAutoThread=bb;table.insert(l.tasks,bb)end;bo.setAutoWinPads=function(bT)if not l.alive then return nil,"instance_destroyed"end;if bT and l.autofarm and l.autofarm.enabled then l.autofarm:Stop("Auto wins enabled")end;l.autoWinPads=bT==true;if not l.autoWinPads and not l.autoJumpUpgrade and e and e.details==l.padAutoTeleport then f()end;if l.autoWinPads then cw()end;return true end;bo.setAutoJumpUpgrade=function(bT)if not l.alive then return nil,"instance_destroyed"end;if bT and l.autofarm and l.autofarm.enabled then l.autofarm:Stop("Auto jump upgrade enabled")end;l.autoJumpUpgrade=bT==true;if not l.autoWinPads and not l.autoJumpUpgrade and e and e.details==l.padAutoTeleport then f()end;if l.autoJumpUpgrade then cw()end;return true end;local cA=[====[
-- Bundled by build.ps1. One cancellable coordinator; no Marketplace purchase calls.
return function(context)
    local state, api = context.state, context.api
    local game = context.game or game
    local workspace = context.workspace or workspace
    local scheduler = context.task or task
    local clock = context.clock or os.clock
    local player = game:GetService("Players").LocalPlayer
    local shared = game:GetService("ReplicatedStorage").Shared
    local config = context.config or require(shared.Config)
    local worlds = context.worlds or require(shared.WorldConfig)
    local rebirth = context.rebirth or require(shared.RebirthConfig)
    local trails = context.trails or require(shared.TrailConfig)
    local net = context.net or require(shared.Net)
    local collection = game:GetService("CollectionService")
    local defaults = {
        train = true, rebirth = true, wins = true, jumpPads = true, morphs = true,
        trails = true, advance = true, bedBoost = true, bed = "Best owned", side = "Either",
        forceWins = false, winTiming = "Auto", winInterval = 10,
        minBedSeconds = 5, maxBedSeconds = 30, etaMargin = 1.15,
        winClaims = 3, winBudgetSeconds = 8, winCooldown = 3,
        actionTimeout = 8, bedContactTimeout = 6, maxFailures = 3, retryDelay = 3,
        cycleDelay = 1, maxWorld = 4, stopAfterCycles = 0,
    }
    local ranges = {
        minBedSeconds = {5, 60, 1}, maxBedSeconds = {5, 120, 1}, etaMargin = {1, 3, 100},
        winInterval = {5, 120, 1},
        winClaims = {1, 30, 1}, winBudgetSeconds = {2, 120, 1}, winCooldown = {2, 30, 10},
        actionTimeout = {3, 30, 1}, bedContactTimeout = {3, 30, 1}, maxFailures = {1, 10, 1},
        retryDelay = {1, 30, 1}, cycleDelay = {0.5, 30, 10}, maxWorld = {1, 4, 1}, stopAfterCycles = {0, 10000, 1},
    }
    local af = { enabled = false, alive = true, settings = table.clone(defaults), defaults = defaults,
        ranges = ranges, status = "Stopped", phase = "Stopped", generation = 0,
        cycles = 0, failures = 0, requests = 0, confirmedWins = 0, history = {}, teleportStreams = {}, currency = "Wins/free only" }
    local paidKeys = { "RobuxPrice", "RobuxCost", "ProductId", "DeveloperProductId", "GamePassId", "GamepassId", "PurchaseId" }
    local allowedRequests = { RebirthDo = true, WorldTravel = true, TrailGetState = true,
        TrailBuy = true, TrailEquip = true, BedBoostClaim = true }
    local function finite(value) return type(value) == "number" and value == value and math.abs(value) < math.huge end
    local function free(object)
        if not object then return false end
        local depth = 0
        while object and object ~= workspace and depth < 16 do
            for _, key in ipairs(paidKeys) do
                local value = object:GetAttribute(key)
                if value ~= nil and value ~= false and value ~= 0 and value ~= "" then return false end
            end
            local currency = object:GetAttribute("Currency")
            if currency ~= nil and currency ~= "Wins" and currency ~= "Free" then return false end
            object, depth = object.Parent, depth + 1
        end
        return object == nil or object == workspace
    end
    local function winsTrail(info)
        if not finite(info.Wins) or info.Wins < 0 or info.Limited or info.ShopOnly then return false end
        if info.Currency ~= nil and info.Currency ~= "Wins" then return false end
        for _, key in ipairs(paidKeys) do
            local value = info[key]
            if value ~= nil and value ~= false and value ~= 0 and value ~= "" then return false end
        end
        return true
    end
    local function log(phase, detail)
        af.phase, af.status = phase, detail or phase
        table.insert(af.history, { time = clock(), phase = phase, detail = af.status })
        if #af.history > 40 then table.remove(af.history, 1) end
    end
    local function removeTask(thread)
        local i = table.find(state.tasks, thread)
        if i then table.remove(state.tasks, i) end
    end
    local function valid(token, snapshot)
        if not state.alive or not af.alive or not af.enabled or af.generation ~= token then return false end
        if not snapshot then return true end
        local h = snapshot.character and snapshot.character:FindFirstChildOfClass("Humanoid")
        return player.Character == snapshot.character and h and h.Health > 0
            and api.detectWorld() == snapshot.world
            and player:GetAttribute("WorldTravelSequence") == snapshot.sequence
            and player:GetAttribute("WorldChanging") ~= true
    end
    local function snapshot()
        local character = player.Character
        local h = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local world = api.detectWorld()
        if not world or not root or not h or h.Health <= 0 or player:GetAttribute("WorldChanging") == true
            or player:GetAttribute("WorldProgressReady") == false or player:GetAttribute("CarryingBox") == true
            or player:GetAttribute("BoxOpening") == true or h.SeatPart then return nil end
        return { world = world, sequence = player:GetAttribute("WorldTravelSequence"), character = character, root = root }
    end
    local function waitFor(token, seconds, predicate, snap)
        local deadline = clock() + seconds
        repeat
            if not valid(token, snap) then return false, "interrupted" end
            if predicate and predicate() then return true end
            scheduler.wait(0.05)
        until clock() >= deadline
        return valid(token, snap) and (not predicate or predicate()), "timeout"
    end
    local function request(token, name, argument, snap)
        if not allowedRequests[name] then return nil, "request_not_allowed" end
        if not valid(token, snap) then return nil, "interrupted" end
        if af.pending then return nil, "previous_request_pending" end
        local pending = { name = name, done = false }
        af.pending = pending
        af.requests = af.requests + 1
        local thread
        thread = scheduler.defer(function()
            pending.ok, pending.result = pcall(function()
                if argument == nil then return net:Invoke(name) end
                return net:Invoke(name, argument)
            end)
            pending.done = true
            if af.pending == pending then af.pending = nil end
            removeTask(thread)
        end)
        table.insert(state.tasks, thread)
        local done = waitFor(token, af.settings.actionTimeout, function() return pending.done end,
            name ~= "WorldTravel" and snap or nil)
        if not done then
            if not pending.done then af.uncertainRequest = name end
            return nil, pending.done and "interrupted" or "request_pending_" .. name
        end
        if not pending.ok then return nil, tostring(pending.result) end
        if type(pending.result) ~= "table" or pending.result.ok ~= true then
            return nil, type(pending.result) == "table" and tostring(pending.result.error or pending.result.message) or "invalid_response"
        end
        af.uncertainRequest = nil
        return pending.result
    end
    local function releaseTeleport()
        if af.teleport and af.teleport == state.lastTeleport and af.teleport.holding then api.cancelTeleportHold() end
        af.teleport = nil
    end
    local function stream(token, position, snap)
        if not valid(token, snap) then return false end
        local done = false
        local thread
        thread = scheduler.defer(function()
            pcall(function() player:RequestStreamAroundAsync(position, 1) end)
            done = true
        end)
        af.streamThread = thread
        table.insert(state.tasks, thread)
        local complete = waitFor(token, math.min(2, af.settings.actionTimeout), function() return done end, snap)
        if not done then pcall(scheduler.cancel, thread) end
        removeTask(thread)
        if af.streamThread == thread then af.streamThread = nil end
        return complete
    end
    local function arrive(token, ok, detail, snap)
        if not ok then return nil, tostring(detail) end
        af.teleport = detail.teleport or detail
        local arrived = waitFor(token, af.settings.actionTimeout, function()
            return af.teleport and af.teleport.groundConfirmed and not af.teleport.holding
        end, snap)
        releaseTeleport()
        if not arrived then return nil, valid(token, snap) and "ground_not_confirmed" or "interrupted" end
        return true
    end
    local function totalXP()
        local level, xp = player:GetAttribute("Level"), player:GetAttribute("XP")
        if not finite(level) or not finite(xp) then return nil end
        local base = config.TotalXPForLevel(level)
        if not finite(base) then return nil end
        return base + xp
    end
    local function nextWorld(world)
        local target = world + 1
        if af.settings.advance and target <= af.settings.maxWorld and target <= 4 and worlds.Enabled(target)
            and player:GetAttribute("World" .. target .. "Unlocked") == true then return target end
    end
    local function unlockReady(world)
        local target = world + 1
        if not af.settings.advance or target > af.settings.maxWorld or target > 4 or not worlds.Enabled(target)
            or player:GetAttribute("World" .. target .. "Unlocked") == true then return false end
        local info = worlds.Get and worlds.Get(target)
        return info and finite(info.ENTRY_LEVEL) and finite(info.ENTRY_REBIRTHS)
            and (player:GetAttribute("Level") or 0) >= info.ENTRY_LEVEL
            and (player:GetAttribute("Rebirths") or 0) >= info.ENTRY_REBIRTHS
    end
    local function bestBed()
        local selected
        local rank = { Red = 1.5, Emerald = 2, Gold = 5, Diamond = 20, Obsidian = 150 }
        for _, bed in ipairs(api.getOwnedBeds() or {}) do
            if af.settings.bed == "Best owned" or af.settings.bed == bed.tier then
                if not selected or (bed.multiplier or rank[bed.tier] or 0) > (selected.multiplier or rank[selected.tier] or 0) then selected = bed end
            end
        end
        return selected
    end
    local function bestMorph(world)
        local selected
        local owned = player:GetAttribute("Rebirths") or 0
        local current = player:GetAttribute("RebirthMorphMultiplier") or 1
        local currentId = player:GetAttribute("RebirthMorph")
        for _, info in ipairs(config.REBIRTH_MORPHS or {}) do
            if info.id == currentId then current = info.multiplier break end
        end
        for _, info in ipairs(config.REBIRTH_MORPHS or {}) do
            if (info.world or 1) == world and owned >= info.rebirths and info.multiplier > current
                and (not selected or info.multiplier > selected.multiplier) then selected = info end
        end
        return selected
    end
    local function bestJump()
        local selected
        local bonus, wins = player:GetAttribute("StepBonus") or 0, player:GetAttribute("Wins") or 0
        for _, info in ipairs(api.getJumpPads() or {}) do
            if info.bonus > bonus and finite(info.cost) and info.cost >= 0 and (info.owned or wins >= info.cost)
                and (not info.pad or free(info.pad)) and (not selected or info.bonus > selected.bonus) then selected = info end
        end
        return selected
    end
    local function effectiveTrailMultiplier(serverState)
        local reported = player:GetAttribute("TrailMultiplier")
        local id = serverState and serverState.equipped or player:GetAttribute("EquippedTrail")
        local info = id and trails.Trails[id]
        return math.max(finite(reported) and reported or 1, info and info.Multiplier or 1)
    end
    local function purchaseDemand(world, ownedTrails)
        local selected
        local wins = player:GetAttribute("Wins") or 0
        local function consider(name, price)
            if price > wins and (not selected or price < selected.cost) then
                selected = { name = name, cost = price, shortfall = price - wins }
            end
        end
        if af.settings.jumpPads then
            local bonus = player:GetAttribute("StepBonus") or 0
            for _, info in ipairs(api.getJumpPads() or {}) do
                if not info.owned and info.bonus > bonus and finite(info.cost) and info.cost >= 0
                    and (not info.pad or free(info.pad)) then consider(info.name, info.cost) end
            end
        end
        if af.settings.trails then
            if not ownedTrails then return nil, "trail_ownership_unknown" end
            local multiplier = effectiveTrailMultiplier(af.trailState)
            for name, info in pairs(trails.Trails) do
                if winsTrail(info) and not ownedTrails[name] and info.Multiplier > multiplier
                    and (not info.World or info.World <= world) then consider(name, info.Wins) end
            end
        end
        return selected
    end
    local function wantsWins()
        return af.settings.wins and (af.settings.forceWins or af.purchaseDemand ~= nil)
    end
    local function refreshDemand(token, snap)
        if af.settings.trails and not af.trailState then
            local result, err = request(token, "TrailGetState", nil, snap)
            if not result then return nil, err end
            if type(result.owned) ~= "table" then return nil, "trail_ownership_not_ready" end
            af.trailState = result
        end
        local demand, err = purchaseDemand(snap.world, af.trailState and af.trailState.owned)
        if err then return nil, err end
        af.purchaseDemand = demand
        af.winReason = af.settings.forceWins and "Forced win farming" or demand and ("Saving for " .. demand.name) or "No upgrades to fund"
        return true
    end
    local function topPad()
        local selected
        for _, info in ipairs(api.getWinPads() or {}) do
            if info.padType == "Yellow" and (not info.pad or free(info.pad))
                and (af.settings.side == "Either" or info.side == af.settings.side)
                and (not selected or info.rewardColumn > selected.rewardColumn) then selected = info end
        end
        return selected
    end
    function af:Plan()
        local world = api.detectWorld()
        if not world then return nil, "world_not_ready" end
        local bed, pad, jump, morph = bestBed(), topPad(), bestJump(), bestMorph(world)
        return { world = world, nextWorld = nextWorld(world), bed = bed and bed.tier,
            winColumn = pad and pad.rewardColumn, jumpPad = jump and jump.name, morph = morph and morph.id,
            rebirthLevel = rebirth.ReqLevel(player:GetAttribute("Rebirths") or 0, world),
            winTiming = self.settings.winTiming, forceWins = self.settings.forceWins,
            purchaseDemand = self.purchaseDemand,
            currency = self.currency, settings = table.clone(self.settings) }
    end
    local function travel(token, snap)
        local target = nextWorld(snap.world)
        if not target then return false end
        log("Travel", "Advancing to World " .. target)
        releaseTeleport()
        local response, reason = request(token, "WorldTravel", target, snap)
        if not response then return nil, reason end
        local arrived = waitFor(token, af.settings.actionTimeout, function()
            local current = snapshot()
            return current and current.world == target and current.sequence ~= snap.sequence
                and player:GetAttribute("WorldProgressReady") ~= false
        end)
        if not arrived then return nil, "travel_arrival_unconfirmed" end
        af.rate, af.eta, af.activeBedSeconds = nil, nil, 0
        api.refreshPads()
        log("Travel confirmed", "World " .. target)
        return true
    end
    local function morph(token, snap)
        if not af.settings.morphs then return true end
        local info = bestMorph(snap.world)
        if not info then return true end
        local part
        for _, candidate in ipairs(collection:GetTagged(config.REBIRTH_MORPH_TAG or "RebirthMorphPad")) do
            if candidate:IsA("BasePart") and (candidate:GetAttribute("WorldId") or 1) == snap.world
                and candidate:GetAttribute("MorphId") == info.id and free(candidate) then part = candidate break end
        end
        if not part then
            stream(token, worlds.OffsetFor(snap.world) + Vector3.new(138, 8, 156), snap)
            return nil, "morph_pad_not_loaded"
        end
        log("Morph", "Equipping " .. info.id)
        local h = snap.character:FindFirstChildOfClass("Humanoid")
        -- These pads can be rotated: local Y is not necessarily world up.
        local cf, size = part.CFrame, part.Size
        local extentY = (math.abs(cf.RightVector.Y) * size.X + math.abs(cf.UpVector.Y) * size.Y
            + math.abs(cf.LookVector.Y) * size.Z) / 2
        local target = CFrame.new(cf.Position + Vector3.new(0, extentY + h.HipHeight + snap.root.Size.Y / 2 + 0.5, 0)) * snap.root.CFrame.Rotation
        local ok, detail = api.teleportToPosition(target, { worldId = snap.world })
        local moved, reason = arrive(token, ok, detail, snap)
        if not moved then return nil, reason end
        if not waitFor(token, af.settings.actionTimeout, function() return player:GetAttribute("RebirthMorph") == info.id end, snap) then
            return nil, "morph_equip_unconfirmed"
        end
        af.rate, af.eta = nil, nil
        return true
    end
    local function train(token, snap)
        if not af.settings.train then af.activeBedSeconds = 0 return true end
        local bed = bestBed()
        if not bed then return nil, "no_owned_bed" end
        -- Already-owned beds use the owned-bed path; no entitlement is purchased.
        log("Bed arrival", "Training on " .. bed.tier)
        local ok, detail = api.teleportToBed(bed.tier, { worldId = snap.world })
        local moved, reason = arrive(token, ok, detail, snap)
        if not moved then return nil, reason end
        if not waitFor(token, af.settings.bedContactTimeout, function() return player:GetAttribute("OnBed") == true end, snap) then
            return nil, "bed_contact_unconfirmed"
        end
        local active, lostSince = 0, nil
        local lastTime, lastXP, sampleTime = clock(), totalXP(), clock()
        local samples = {}
        local count = player:GetAttribute("Rebirths") or 0
        local target = rebirth.ReqLevel(count, snap.world)
        local targetXP = config.TotalXPForLevel(target)
        local farming = wantsWins()
        local function winBedLimit()
            if af.settings.forceWins or af.settings.winTiming == "Auto" then return af.settings.minBedSeconds end
            return math.max(af.settings.minBedSeconds, af.settings.winInterval)
        end
        local limit = farming and winBedLimit() or af.settings.minBedSeconds
        af.activeBedSeconds, af.plannedBedSeconds = 0, limit
        local deadline = clock() + math.max(af.settings.maxBedSeconds, limit) * 3 + af.settings.bedContactTimeout
        while valid(token, snap) and clock() < deadline do
            local now = clock()
            local dt = math.min(0.25, now - lastTime)
            lastTime = now
            local onBed = player:GetAttribute("OnBed") == true
            if onBed then
                lostSince = nil
                active = active + dt
                af.activeBedSeconds = active
                if af.settings.bedBoost and now >= (af.nextBoostAttempt or 0)
                    and workspace:GetServerTimeNow() >= (player:GetAttribute("BedBoostReadyAt") or 0) then
                    af.nextBoostAttempt = now + 5
                    local response, err = request(token, "BedBoostClaim", nil, snap)
                    if not response and err and err:find("request_pending", 1, true) then return nil, err end
                    lastTime = clock() -- request/latency time does not inflate active bed time
                end
            else
                lostSince = lostSince or now
                if now - lostSince > af.settings.bedContactTimeout then return nil, "bed_contact_lost" end
            end
            if now - sampleTime >= 1 then
                local xp = totalXP()
                if onBed and xp and lastXP and xp >= lastXP and (player:GetAttribute("Rebirths") or 0) == count then
                    local sample = (xp - lastXP) / (now - sampleTime)
                    if finite(sample) and sample > 0 then
                        table.insert(samples, sample)
                        if #samples > 5 then table.remove(samples, 1) end
                        local ordered = table.clone(samples)
                        table.sort(ordered)
                        af.rate = ordered[math.ceil(#ordered / 2)]
                    end
                end
                lastXP, sampleTime = xp, now
                if af.rate and xp and finite(targetXP) then
                    af.eta = math.max(0, targetXP - xp) / af.rate
                    if not farming then
                        limit = math.clamp(math.ceil(af.settings.etaMargin * af.eta) + active,
                            af.settings.minBedSeconds, af.settings.maxBedSeconds)
                    end
                end
                if farming then
                    limit = winBedLimit()
                    -- Auto funds upgrades promptly; only allow a small extension
                    -- for an imminent rebirth, rather than waiting for a distant ETA.
                    if af.settings.rebirth and not af.settings.forceWins and af.settings.winTiming == "Auto" and af.eta and af.eta <= 2 then
                        limit = math.min(af.settings.minBedSeconds + 2, math.max(limit, math.ceil(active + af.eta)))
                    end
                end
                af.plannedBedSeconds = limit
                log("Training", string.format("Bed %.1f / %.1fs", active, limit))
            end
            if active >= af.settings.minBedSeconds then
                if nextWorld(snap.world) or (not farming and rebirth.CanRebirth(count, player:GetAttribute("Level") or 0, snap.world)) or active >= limit then
                    if not af.rate and not nextWorld(snap.world)
                        and not rebirth.CanRebirth(count, player:GetAttribute("Level") or 0, snap.world) then
                        return nil, "no_measured_bed_gain"
                    end
                    af.lastBedVisit = { activeSeconds = active, plannedSeconds = limit, world = snap.world,
                        rate = af.rate, finishedAt = clock() }
                    return true
                end
            end
            scheduler.wait(0.1)
        end
        return nil, valid(token, snap) and "bed_visit_timeout" or "interrupted"
    end
    local function doRebirth(token, snap)
        if not af.settings.rebirth then return true end
        local count, level = player:GetAttribute("Rebirths") or 0, player:GetAttribute("Level") or 0
        if not rebirth.CanRebirth(count, level, snap.world) then return true end
        if af.settings.train and (not af.lastBedVisit or af.lastBedVisit.activeSeconds < af.settings.minBedSeconds) then return nil, "minimum_bed_time_not_met" end
        log("Rebirth", "Free rebirth")
        local response, reason = request(token, "RebirthDo", nil, snap)
        if not response then return nil, reason end
        if not waitFor(token, af.settings.actionTimeout, function()
            return (player:GetAttribute("Rebirths") or 0) > count and (player:GetAttribute("Level") or level) < level
        end, snap) then
            return nil, "rebirth_unconfirmed"
        end
        af.rate, af.eta, af.lastBedVisit = nil, nil, nil
        return true
    end
    local function farmWins(token, snap, unlockAttempt)
        if not af.settings.wins and not unlockAttempt then return true end
        if not unlockAttempt and not wantsWins() then
            log("Wins skipped", af.winReason or "No upgrades to fund")
            return true
        end
        local info = topPad()
        if not info then return nil, "no_free_win_pad" end
        local deadline = clock() + af.settings.winBudgetSeconds
        for _ = 1, unlockAttempt and 1 or af.settings.winClaims do
            if not valid(token, snap) then return nil, "interrupted" end
            if clock() >= deadline then break end
            local before = player:GetAttribute("Wins") or 0
            if not info.pad then
                log("Loading wins", "Loading free top win pad")
                local tower = worlds.TowerFor and worlds.TowerFor(snap.world)
                local summit = tower and tower:FindFirstChild("SummitMessage")
                local summitPivot = summit and summit:IsA("Model") and summit:GetPivot()
                stream(token, summitPivot and summitPivot.Position or info.streamPosition or worlds.OffsetFor(snap.world), snap)
                if not valid(token, snap) then return nil, "interrupted" end
                local function findLoaded()
                    for _, candidate in ipairs(api.getWinPads() or {}) do
                        if candidate.rewardColumn == info.rewardColumn and candidate.padType == "Yellow" and candidate.pad and free(candidate.pad)
                            and (af.settings.side == "Either" or candidate.side == af.settings.side) then info = candidate return true end
                    end
                    return false
                end
                if not findLoaded() and summitPivot then
                    -- Stage above a persistent decoration, away from the pads. Hold there
                    -- while streaming, inspect actual currency metadata, then touch Yellow.
                    local moved, staging = api.teleportToPosition(summitPivot + Vector3.new(0, 12, 0), { worldId = snap.world })
                    if not moved then return nil, tostring(staging) end
                    af.teleport = staging
                    waitFor(token, af.settings.actionTimeout, findLoaded, snap)
                end
                if not info.pad then return nil, "win_pad_currency_not_loaded" end
            end
            if not free(info.pad) then return nil, "paid_win_pad_blocked" end
            log(unlockAttempt and "World completion" or "Wins", "Free column " .. info.rewardColumn)
            local ok, detail = api.teleportToWinPad(info.rewardColumn, { worldId = snap.world,
                padType = "Yellow", side = af.settings.side ~= "Either" and af.settings.side or nil })
            local moved, reason = arrive(token, ok, detail, snap)
            if not moved then return nil, reason end
            local confirmed = waitFor(token, af.settings.actionTimeout,
                function() return (player:GetAttribute("Wins") or 0) > before end, snap)
            if not confirmed then return nil, "win_award_unconfirmed" end
            af.confirmedWins = af.confirmedWins + 1
            if not unlockAttempt and not af.settings.forceWins and af.purchaseDemand
                and (player:GetAttribute("Wins") or 0) >= af.purchaseDemand.cost then break end
            if clock() >= deadline then break end
            if not waitFor(token, af.settings.winCooldown, nil, snap) then return nil, "interrupted" end
        end
        return true
    end
    local function upgradeJump(token, snap)
        if not af.settings.jumpPads then return true end
        local info = bestJump()
        if not info then return true end
        -- Never touch an uninspected streamed placeholder: check its live currency metadata.
        if not info.pad then
            stream(token, worlds.OffsetFor(snap.world) + Vector3.new(0, 8, 0), snap)
            return nil, "jump_pad_currency_not_loaded"
        end
        if not free(info.pad) then return nil, "paid_jump_pad_blocked" end
        log("Jump upgrade", info.name)
        local ok, detail = api.teleportToJumpPad(info.name, { worldId = snap.world })
        local moved, reason = arrive(token, ok, detail, snap)
        if not moved then return nil, reason end
        if not waitFor(token, af.settings.actionTimeout, function()
            local folder = player:FindFirstChild("StepPads")
            local value = folder and folder:FindFirstChild(info.name)
            local owned = value and (not value:IsA("BoolValue") or value.Value == true)
            return owned and player:GetAttribute("EquippedStepPad") == info.name and (player:GetAttribute("StepBonus") or 0) >= info.bonus
        end, snap) then return nil, "jump_upgrade_unconfirmed" end
        af.rate, af.eta = nil, nil
        return true
    end
    local function upgradeTrail(token, snap)
        if not af.settings.trails then return true end
        local result, reason = af.trailState, nil
        if not result then result, reason = request(token, "TrailGetState", nil, snap) end
        if not result then return nil, reason end
        if type(result.owned) ~= "table" then return nil, "trail_ownership_not_ready" end
        af.trailState = result
        local selected, id
        local current = effectiveTrailMultiplier(result)
        local wins = player:GetAttribute("Wins") or 0
        for name, info in pairs(trails.Trails) do
            if winsTrail(info)
                and (not info.World or info.World <= snap.world) and info.Multiplier > current
                and (result.owned[name] == true or wins >= info.Wins)
                and (not selected or info.Multiplier > selected.Multiplier) then selected, id = info, name end
        end
        if not selected then return true end
        log("Trail upgrade", id)
        if not result.owned[id] then
            -- Only a verified finite Wins price reaches this request.
            local bought, err = request(token, "TrailBuy", id, snap)
            if not bought then return nil, err end
            local fresh, readErr = request(token, "TrailGetState", nil, snap)
            if not fresh then return nil, readErr end
            if not fresh.owned or fresh.owned[id] ~= true then return nil, "trail_purchase_unconfirmed" end
            af.trailState = fresh
        end
        local equipped, err = request(token, "TrailEquip", id, snap)
        if not equipped and err == "ALREADY_EQUIPPED" and player:GetAttribute("EquippedTrail") == id then return true end
        if not equipped then return nil, err end
        if not waitFor(token, af.settings.actionTimeout, function() return player:GetAttribute("EquippedTrail") == id end, snap) then
            return nil, "trail_equip_unconfirmed"
        end
        af.rate, af.eta = nil, nil
        return true
    end
    function af:Stop(reason)
        self.enabled = false
        self.generation = self.generation + 1
        state.autofarmBusy = false
        releaseTeleport()
        for thread in pairs(self.teleportStreams) do
            pcall(scheduler.cancel, thread)
            removeTask(thread)
            self.teleportStreams[thread] = nil
        end
        if self.streamThread then
            pcall(scheduler.cancel, self.streamThread)
            removeTask(self.streamThread)
            self.streamThread = nil
        end
        if self.thread then
            if self.thread ~= coroutine.running() then pcall(scheduler.cancel, self.thread) end
            removeTask(self.thread)
            self.thread = nil
        end
        if self.savedMovement and state.alive then
            api.resetPlayerMovement()
            api.setPlayerMovement(self.savedMovement)
            if state.ui and state.ui.movement then state.ui.movement.sync() end
        end
        self.savedMovement = nil
        log("Stopped", reason or "Stopped")
        if state.ui and state.ui.autofarm and state.ui.autofarm.setEnabled then state.ui.autofarm.setEnabled(false) end
        return true
    end
    function af:Configure(values)
        if type(values) ~= "table" then return nil, "invalid_settings" end
        local settings = table.clone(self.settings)
        for key, value in pairs(values) do
            if defaults[key] == nil then return nil, "unknown_setting_" .. tostring(key) end
            if ranges[key] then
                local range = ranges[key]
                if not finite(value) or value < range[1] or value > range[2]
                    or range[3] == 1 and value % 1 ~= 0 then return nil, "invalid_" .. key end
            elseif type(defaults[key]) == "boolean" then
                if type(value) ~= "boolean" then return nil, "invalid_" .. key end
            elseif key == "bed" then
                if not table.find({"Best owned", "Red", "Emerald", "Gold", "Diamond", "Obsidian"}, value) then return nil, "invalid_bed" end
            elseif key == "side" and not table.find({"Either", "Left", "Right"}, value) then return nil, "invalid_side"
            elseif key == "winTiming" and not table.find({"Auto", "Manual"}, value) then return nil, "invalid_win_timing" end
            settings[key] = value
        end
        if settings.maxBedSeconds < settings.minBedSeconds then return nil, "maximum_bed_time_below_minimum" end
        if values.forceWins == true then settings.wins = true end
        if values.wins == false then settings.forceWins = false end
        if self.enabled then self:Stop("Settings changed; start again") end
        self.settings = settings
        self.purchaseDemand, self.trailState, self.winReason = nil, nil, nil
        state.autofarmSettings = settings
        return true
    end
    function af:Start()
        if not state.alive or not self.alive then return nil, "instance_destroyed" end
        if self.enabled then return true end
        if self.pending then return nil, "request_still_pending" end
        if not snapshot() then return nil, "character_or_world_not_ready" end
        api.setBoxCapture(false)
        api.setAutoWinPads(false)
        api.setAutoJumpUpgrade(false)
        if state.padAutoThread then
            pcall(scheduler.cancel, state.padAutoThread)
            removeTask(state.padAutoThread)
            state.padAutoThread = nil
        end
        if state.ui then
            state.ui.boxToggle:Set(false)
            state.ui.autoWinToggle:Set(false) state.ui.autoUpgradeToggle:Set(false)
        end
        api.cancelTeleportHold()
        self.savedMovement = state.movement and table.clone(state.movement.values) or {}
        api.resetPlayerMovement()
        if state.ui and state.ui.movement then state.ui.movement.sync() end
        self.enabled = true
        self.generation = self.generation + 1
        self.cycles, self.failures, self.confirmedWins, self.rate, self.lastBedVisit = 0, 0, 0, nil, nil
        self.eta, self.activeBedSeconds, self.plannedBedSeconds = nil, 0, self.settings.minBedSeconds
        self.lastError, self.uncertainRequest = nil, nil
        self.purchaseDemand, self.trailState = nil, nil
        local token = self.generation
        state.autofarmBusy = true
        log("Starting", "Wins/free only; Robux actions blocked")
        local thread
        thread = scheduler.defer(function()
            while valid(token) do
                local snap = snapshot()
                if not snap then
                    log("Waiting", "Waiting for live character/world")
                    waitFor(token, 1)
                else
                    local ok, success, reason = pcall(function()
                        self.trailState = nil
                        local advanced, err = travel(token, snap)
                        if advanced == nil then return nil, err end
                        if advanced then return true, "advanced" end
                        local good, failure = morph(token, snap)
                        if not good then return nil, failure end
                        -- Apply affordable/owned improvements before deciding whether
                        -- more wins are needed. Maxed equipment should stay on the bed.
                        good, failure = upgradeJump(token, snap)
                        if not good then return nil, failure end
                        good, failure = upgradeTrail(token, snap)
                        if not good then return nil, failure end
                        good, failure = refreshDemand(token, snap)
                        if not good then return nil, failure end
                        good, failure = train(token, snap)
                        if not good then return nil, failure end
                        advanced, err = travel(token, snap)
                        if advanced == nil then return nil, err end
                        if advanced then return true, "advanced" end
                        -- Attempt the normal free world-completion reward before a
                        -- rebirth resets an already-earned entry level. Never guess an unlock remote.
                        if unlockReady(snap.world) then
                            good, failure = farmWins(token, snap, true)
                            if not good then return nil, failure end
                            advanced, err = travel(token, snap)
                            if advanced == nil then return nil, err end
                            if advanced then return true, "advanced" end
                        end
                        good, failure = doRebirth(token, snap)
                        if not good then return nil, failure end
                        good, failure = morph(token, snap)
                        if not good then return nil, failure end
                        good, failure = farmWins(token, snap)
                        if not good then return nil, failure end
                        good, failure = upgradeJump(token, snap)
                        if not good then return nil, failure end
                        good, failure = upgradeTrail(token, snap)
                        if not good then return nil, failure end
                        good, failure = morph(token, snap)
                        if not good then return nil, failure end
                        advanced, err = travel(token, snap)
                        if advanced == nil then return nil, err end
                        return true
                    end)
                    if not valid(token) then break end
                    if not ok then reason, success = tostring(success), nil end
                    if success then
                        self.failures = 0
                        self.lastError = nil
                        self.cycles = self.cycles + 1
                        if self.settings.stopAfterCycles > 0 and self.cycles >= self.settings.stopAfterCycles then
                            self:Stop("Cycle limit reached") break
                        end
                        log("Cycle complete", "Completed cycles: " .. self.cycles)
                        waitFor(token, self.settings.cycleDelay)
                    elseif not valid(token, snap) and reason == "interrupted" then
                        self.rate, self.lastBedVisit = nil, nil
                        releaseTeleport()
                        log("Replanning", "Character/world changed")
                        waitFor(token, 1)
                    else
                        releaseTeleport()
                        self.failures = self.failures + 1
                        self.lastError = tostring(reason)
                        if self.uncertainRequest or self.failures >= self.settings.maxFailures then
                            self:Stop("Paused: " .. self.lastError) break
                        end
                        log("Retry", self.lastError)
                        waitFor(token, self.settings.retryDelay * self.failures)
                    end
                end
            end
            if self.thread == thread then self.thread = nil end
            removeTask(thread)
        end)
        self.thread = thread
        table.insert(state.tasks, thread)
        if state.ui and state.ui.autofarm and state.ui.autofarm.setEnabled then state.ui.autofarm.setEnabled(true) end
        return true
    end
    function af:Destroy()
        self:Stop("Unloaded")
        self.alive = false
    end
    if context.saved then af:Configure(context.saved) end
    return af
end

]====]local cB,cC=loadstring(cA,"VerityAutofarm")if not cB then error(cC)end;local cD=cB()({state=l,api=bo,saved=br and br.autofarmSettings})l.autofarm=cD;bo.startAutofarm=function(cE)if cE then local v,bE=cD:Configure(cE)if not v then return nil,bE end end;return cD:Start()end;bo.stopAutofarm=function()return cD:Stop()end;bo.configureAutofarm=function(cE)return cD:Configure(cE)end;bo.getAutofarmPlan=function()return cD:Plan()end;bo.getAutofarmStatus=function()return{enabled=cD.enabled,phase=cD.phase,status=cD.status,cycles=cD.cycles,failures=cD.failures,lastError=cD.lastError,rate=cD.rate,eta=cD.eta,activeBedSeconds=cD.activeBedSeconds,plannedBedSeconds=cD.plannedBedSeconds,confirmedWins=cD.confirmedWins,winReason=cD.winReason,purchaseDemand=cD.purchaseDemand and table.clone(cD.purchaseDemand),pending=cD.pending and cD.pending.name,settings=table.clone(cD.settings),lastBedVisit=cD.lastBedVisit and table.clone(cD.lastBedVisit),currency=cD.currency}end;bo.resetAutofarmSettings=function()return cD:Configure(cD.defaults)end;local function cF()local cG=game:GetService("Players")local cH=game:GetService("VirtualInputManager")local cI=game:GetService("StarterGui")local cJ=cG.LocalPlayer;if getconnections then for P,cK in getconnections(cJ.Idled)do pcall(function()cK:Disable()end)pcall(function()cK:Disconnect()end)end end;cJ.Idled:Connect(function()cH:SendMouseButtonEvent(0,0,0,true,game,0)task.wait(0.1)cH:SendMouseButtonEvent(0,0,0,false,game,0)end)pcall(function()cI:SetCore("SendNotification",{Title="Anti Idle",Text="Anti-AFK is now active.",Duration=5})end)end;local function cL(bT)if not l.alive then return nil,"instance_destroyed"end;for P,bv in ipairs(l.idleConnections or{})do pcall(function()bv:Disconnect()end)local h=table.find(l.connections,bv)if h then table.remove(l.connections,h)end end;l.idleConnections={}l.antiIdleEnabled=bT==true;if l.settings then l.settings.antiIdle=l.antiIdleEnabled end;if not l.antiIdleEnabled then return true end;cF()if getconnections then for P,bv in ipairs(getconnections(game:GetService("Players").LocalPlayer.Idled))do table.insert(l.idleConnections,bv)table.insert(l.connections,bv)end end;return true end;local function cM()local c,m=a()if not c then error("Cannot initialize: "..tostring(m))end;local cN,cO=loadstring(game:HttpGet("https://raw.githubusercontent.com/ithinkimandrew/roblox/refs/heads/main/depend/ui.lua"),"@ui-lib-edited.lua")if not cN then error(cO)end;setfenv(cN,setmetatable({},{__index=getfenv()}))local bu,cP=cN()l.library=bu;if not l.alive then bt(bu)return end;local cQ=workspace.CurrentCamera.ViewportSize;local cR=math.max(360,math.floor(cQ.X-40))local cS=math.max(460,math.floor(cQ.Y-50))local cT=math.clamp(math.floor(math.min(1000,cQ.X-40)/2),360,cR)local cU=math.min(600,cS)local cV=type(br)=="table"and br.settings or{}local function cW(Q,cX,cY,bR)if type(Q)~="number"or Q~=Q then Q=cX end;return math.clamp(math.floor(Q),cY,bR)end;local cE={toggleKey="RightBracket",width=cW(cV.width,cT,360,cR),height=cW(cV.height,cU,460,cS),refreshInterval=cW(cV.refreshInterval,1,1,5),antiIdle=true,watermark=cV.watermark~=false}if type(cV.toggleKey)=="string"then local v,au=pcall(function()return Enum.KeyCode[cV.toggleKey]end)if v and au and au~=Enum.KeyCode.Unknown and au~=Enum.KeyCode.Escape then cE.toggleKey=au.Name end end;l.settings=cE;local cZ=bu:New({name="Verity Jump Tower",size=Vector2.new(cE.width,cE.height)})l.window=cZ;local c_=cZ:Tab({name="Main"})local d0=c_:Section({name="Win pads",side="left"})local d1=c_:Section({name="Jump upgrades",side="right"})local d2=c_:Section({name="Owned beds",side="left"})local d3=c_:Section({name="Box capture",side="left"})local d4=c_:Section({name="Player modifications",side="right"})local d5=cZ:Tab({name="Autofarm"})local d6=d5:Section({name="Features (free / wins)",side="left"})local d7=d5:Section({name="Settings and progress",side="right"})local d8=cZ:Tab({name="Stats"})local d9=d8:Section({name="All stats (scroll)",side="left"})local da=d8:Section({name="Session",side="right"})local db=cZ:Tab({name="Settings"})local dc=db:Section({name="Window",side="left"})local dd=db:Section({name="Preferences",side="right"})local de={af_enabled="Start or stop all coordinated tasks. Other movement farms pause while this runs.",af_train="Train on an owned bed. Only confirmed OnBed time counts toward the minimum visit.",af_rebirth="Use the free rebirth action once its level requirement and minimum bed time are met.",af_wins="Fund useful jump-pad or trail upgrades with free Yellow pads. Force win pads also farms after gear is maxed.",af_jumpPads="Buy or equip a stronger current-world jump pad when affordable. Unowned pads spend wins.",af_morphs="Equip the strongest current-world rebirth morph you qualify for. Preserves a better equipped morph.",af_trails="Buy or equip a better eligible trail using wins only. Paid and unknown currencies are excluded.",af_advance="Advance to the next enabled world after access is earned. Confirms arrival before rebuilding the plan.",af_bedBoost="Activate the game's on-bed 2x boost: 2 seconds active, then 3 seconds cooldown.",af_forceWins="Farm extra wins even with no upgrades left. Uses Minimum bed seconds, ignoring longer Manual timing.",af_bed="Best owned picks your strongest accessible bed. A specific unowned bed pauses with an error; no pass is bought.",af_side="Choose the left or right free win pad. Either lets the worker choose an available side.",af_winTiming="Auto makes short visits while funding upgrades and skips unnecessary win trips. Manual uses the time slider.",af_winInterval="Active bed time before needed win trips in Manual mode. Moving this slider selects Manual. Force uses the global minimum instead.",af_parameter="Choose a numeric setting to edit below. Hover an option to read its explanation.",af_status="Confirmed progress for this run. Show details displays the full status, pending request and last error.",["Apply parameter"]="Apply the exact number entered above. Invalid values are rejected; changing a setting stops Autofarm.",["Preview plan (no actions)"]="Read proposed targets without moving, buying, rebirthing or claiming rewards.",["Default settings"]="Stop Autofarm and restore its default settings. Robux spending remains permanently disabled.",["Show details"]="Show the current operation, win-farming reason, pending request and full error message.",winColumn="Choose a reward column in the current world. The displayed level is informational; rewards still follow the game's rules.",winVariant="Auto chooses Purple for an owned 2x-wins pass, otherwise Yellow. The coordinated Autofarm always uses free Yellow pads.",winSide="Choose a side of the selected reward column. Either uses an available matching pad.",jumpPad="Choose a jump upgrade. Unowned entries show the wins cost; owned entries can be equipped.",ownedBed="Only beds you can already use are listed. Group and purchased-bed entitlements are checked again before teleporting.",boxType="Select a box rarity, or Auto for the highest available rarity in the current world.",boxCapture="Repeat pickup and delivery. Confirms ownership for 0.3 seconds before taking the clear route to the surface.",boxCaptureStatus="Only server-confirmed deliveries count as captures. A disappeared or dropped box is not counted.",autoWinPads="Repeat the selected Main-tab win pad. This separate worker stops coordinated Autofarm and pauses for other farms.",autoJumpUpgrade="Equip or buy the strongest affordable higher-bonus pad. Unowned upgrades spend their displayed wins cost.",manualWalkSpeed="Apply local walk speed immediately. Reset or unload restores the game's defaults; Autofarm temporarily owns movement.",manualJumpPower="Apply local jump power and enable power-based jumping. Reset restores the original jump mode and values.",exactWalkSpeed="Enter a precise speed from 0 to 500, then click Apply exact values.",exactJumpPower="Enter precise jump power from 0 to 1000, then click Apply exact values. Local changes do not hide movement from the server.",["Apply exact values"]="Validate both text fields and apply them together. Sliders then reflect the actual stored values.",["Reset player defaults"]="Restore WalkSpeed, JumpPower, JumpHeight and the original jump mode. Stop Autofarm first.",["Teleport to win pad"]="Move to the selected current-world pad and wait for supporting ground. Teleporting alone does not guarantee a reward.",["Teleport / buy or equip"]="Touch the selected jump pad. An unowned pad can spend its displayed wins cost.",["Refresh pads"]="Rebuild the current-world pad catalog and request missing streamed parts.",["Teleport to owned bed"]="Move to the chosen bed after checking access and current world.",["Release teleport hold"]="Release the temporary hold used while waiting for ground to load. The character then follows normal physics.",["Capture selected box once"]="Wait for a matching box, pick it up, confirm ownership and deliver once, then stop.",["Stop box capture"]="Cancel box movement and release its held prompt. A box already being carried may need manual delivery.",selectedStat="Select a row, then use Show full selected stat to read a value that was shortened to fit.",sessionStatus="Current world, equipment and session status. This panel updates while the Stats tab is visible.",["Show full selected stat"]="Display the complete selected stat instead of its shortened list text.",["Unload interface"]="Stop workers, disconnect listeners, remove the interface and restore player movement defaults.",uiWidth="Resize the window horizontally within the current screen bounds.",uiHeight="Resize the window vertically. A very short window can make larger sections harder to fit.",statsInterval="Seconds between visible status/stat updates. This does not change farm or pickup timing.",showWatermark="Show or hide the draggable title and live FPS watermark.",settingsSummary="Current interface preferences. The default show/hide key is right bracket (]).",["Bind show/hide key"]="Click, then press the new visibility key. Escape cancels; the default is right bracket (]).",["Center window"]="Place the resized interface in the center of the screen.",["Reset settings"]="Restore default window dimensions, update interval, watermark and right-bracket visibility key."}for P,df in ipairs({d0,d1,d2,d3,d4,d6,d7,d9,da,dc,dd})do for P,dg in ipairs({"Toggle","Slider","Textbox","Dropdown","Button","List"})do local bM=df[dg]df[dg]=function(self,at)at=at or{}if not at.tooltip and not at.tt and not at.ttip then at.tooltip=de[at.flag]or de[at.name]end;local dh=bM(self,at)if dh and type(dh.SetTooltip)~="function"then function dh:SetTooltip(Q)self.tt=type(Q)=="function"and Q()or Q or""end;dh:SetTooltip(at.tooltip or at.tt or at.ttip)end;return dh end end end;local di,dj={},{}local dk=c;local dl=false;local dm=d0:Dropdown({name="Reward column",options={"Loading..."},flag="winColumn",scrollable=true,vis=5})local dn=d0:Dropdown({name="Pad variant",options={"Auto","Yellow","Purple"},flag="winVariant"})local aw=d0:Dropdown({name="Side",options={"Either","Left","Right"},flag="winSide"})local dp=d1:Dropdown({name="Jump pad / cost",options={"Loading..."},flag="jumpPad",scrollable=true,vis=5})local dq=d2:Dropdown({name="Bed",options={"Loading..."},flag="ownedBed",scrollable=true,vis=5})local function dr(df,at)local ds=df:List(at)local dt=ds.Refresh;function ds:Refresh(du)local h=table.find(self.options,self.value)or 1;local dv=self.scroll[1]or 1;local dw=(self.scroll[2]or 10)-dv+1;local dx={}for P,dy in ipairs(self.opinst)do local dz=rawget(dy,"__properties")if dz and dz.Parent then dx[dz.Parent]=true end end;dt(self,du)local function dA(dB,dC)for dD=#dB,1,-1 do local dy=dC and dB[dD][1]or dB[dD]if rawget(dy,"__OBJECT_EXIST")==false then table.remove(dB,dD)end end end;dA(df.instances)for P,bw in pairs(bu.drawings)do dA(bw,true)end;for P,bw in pairs(bu.groups)do dA(bw)end;for dE in pairs(dx)do dA(rawget(dE,"children"))end;self.scroll[1]=math.clamp(dv,1,math.max(1,#du-dw+1))self.scroll[2]=self.scroll[1]+dw-1;self.value=du[math.min(h,#du)]if self.flag then bu.flags[self.flag]=self.value end;for P,dy in ipairs(self.opinst)do local dE=rawget(dy,"__properties").Parent;dy.ZIndex=dE.ZIndex+1;dy.Transparency=dy:getDefaultTransparency()end;self:update()end;return ds end;local dF=dr(d9,{name="Attributes + leaderstats",options={"Loading..."},flag="selectedStat"})local dG=dr(da,{name="Status",options={"Loading..."},flag="sessionStatus"})local dH={"Auto (highest rarity)"}for P,b0 in ipairs(require(game:GetService("ReplicatedStorage").Shared.BoxConfig).Tiers)do if not b0.ShopOnly then table.insert(dH,b0.Name)end end;local dI=d3:Dropdown({name="Box type",options=dH,flag="boxType",scrollable=true,vis=5,callback=function(b1)bo.setBoxCaptureSelection(b1)end})local dJ=d3:Toggle({name="Auto capture boxes",def=false,flag="boxCapture",callback=function(bT)bS(bT)end})d3:Button({name="Capture selected box once",callback=function()dJ:Set(false)bS(true,{once=true})end})d3:Button({name="Stop box capture",callback=function()dJ:Set(false)bS(false)end})local dK=dr(d3,{name="Progress",options={"Stopped","Captured: 0"},rows=2,flag="boxCaptureStatus"})local dL=d0:Toggle({name="Auto teleport to win pad",def=false,flag="autoWinPads",callback=function(bT)bo.setAutoWinPads(bT)end})local dM=d1:Toggle({name="Auto upgrade when affordable",def=false,flag="autoJumpUpgrade",callback=function(bT)bo.setAutoJumpUpgrade(bT)end})l.readAutoWinOptions=function()return di[dm:Get()],{worldId=dk,padType=dn:Get(),side=aw:Get()~="Either"and aw:Get()or nil}end;local dN="Ready. Teleports only run when clicked."local function dO(dP)dN=tostring(dP):gsub("_"," ")if l.alive and cZ.ntiflist then cZ.ntiflist:new({text=dN,duration=4})end end;local dQ,dR=false,false;local dS,dT,dU,dV;local dW=bo.getPlayerMovement()or{WalkSpeed=16,suggestedPower=50}local function dX()local bG=bo.getPlayerMovement()if not bG then return end;dR=true;dS:Set(math.clamp(bG.WalkSpeed,0,500))dT:Set(math.clamp(bG.suggestedPower,0,1000))dU:Set(string.format("%.12g",bG.WalkSpeed))dV:Set(string.format("%.12g",bG.suggestedPower))dR=false end;dS=d4:Slider({name="Walk speed",min=0,max=500,dec=100,def=math.clamp(dW.WalkSpeed,0,500),flag="manualWalkSpeed",callback=function(Q)if dQ and not dR then local v,m=bo.setPlayerMovement({walkSpeed=Q})if v then dX()else dO(m)end end end})dU=d4:Textbox({name="Exact walk speed",def=tostring(dW.WalkSpeed),flag="exactWalkSpeed"})dT=d4:Slider({name="Jump power",min=0,max=1000,dec=100,def=math.clamp(dW.suggestedPower,0,1000),flag="manualJumpPower",callback=function(Q)if dQ and not dR then local v,m=bo.setPlayerMovement({jumpPower=Q})if v then dX()else dO(m)end end end})dV=d4:Textbox({name="Exact jump power",def=tostring(dW.suggestedPower),flag="exactJumpPower"})local function dY()local dZ,d_=tonumber(dU:Get()),tonumber(dV:Get())if not dZ or not d_ then dO("Enter numeric speed and jump power")return nil,"invalid_number"end;local v,m=bo.setPlayerMovement({walkSpeed=dZ,jumpPower=d_})if v then dX()dO("Player modifications applied")else dO(m)end;return v,m end;d4:Button({name="Apply exact values",callback=dY})d4:Button({name="Reset player defaults",callback=function()local v,m=bo.resetPlayerMovement()dX()dO(v and"Player defaults restored"or m)end})dQ=true;dX()local e0,e1=false,false;local e2={}local e3;local function e4(au,Q)if not e0 or e1 then return end;local e5={[au]=Q}if au=="winInterval"then e5.winTiming="Manual"end;local v,m=bo.configureAutofarm(e5)if not v then dO(m)end;if e3 then e3()end end;local e6;e6=d6:Toggle({name="Autofarm enabled",def=false,flag="af_enabled",tooltip="Start or stop the coordinated autofarm.",callback=function(bT)if not e0 or e1 then return end;if bT then local v,m=bo.startAutofarm()if not v then dO(m)e3()end else bo.stopAutofarm()end end})for P,e7 in ipairs({{"train","Train on owned bed"},{"rebirth","Auto rebirth (free)"},{"wins","Farm free win pads","Funds useful upgrades. Enable Force win pads to farm even when nothing is left to buy."},{"jumpPads","Upgrade jump pads (wins)"},{"morphs","Equip best rebirth morph"},{"trails","Best trail (wins only)"},{"advance","Advance worlds (free)"},{"bedBoost","Use 2x bed boost (2s)","Uses the game's bed boost while on the bed: 2 seconds active, then 3 seconds cooldown."},{"forceWins","Force win pads","Farm wins even with no upgrades left. Uses Minimum bed seconds between win trips."}})do local au=e7[1]e2[au]=d6:Toggle({name=e7[2],def=cD.settings[au],flag="af_"..au,tooltip=e7[3],callback=function(Q)e4(au,Q)end})end;local e8=d6:Dropdown({name="Training bed",options={"Best owned","Red","Emerald","Gold","Diamond","Obsidian"},def=cD.settings.bed,flag="af_bed",callback=function(Q)e4("bed",Q)end})local e9=d6:Dropdown({name="Free win-pad side",options={"Either","Left","Right"},def=cD.settings.side,flag="af_side",callback=function(Q)e4("side",Q)end})local ea=d6:Dropdown({name="Win-trip timing",options={"Auto","Manual"},optionTooltips={Auto="Fund useful upgrades after a short minimum bed visit. Skip win pads when nothing remains to buy.",Manual="Use Bed seconds before wins for needed trips. Force win pads instead uses Minimum bed seconds."},def=cD.settings.winTiming,flag="af_winTiming",callback=function(Q)e4("winTiming",Q)end})local eb=d6:Slider({name="Bed seconds before wins",min=5,max=120,dec=1,def=cD.settings.winInterval,flag="af_winInterval",suf="s",callback=function(Q)e4("winInterval",Q)end})local ec={{"Minimum bed seconds","minBedSeconds"},{"Maximum bed seconds","maxBedSeconds"},{"Bed ETA margin","etaMargin"},{"Bed seconds before wins","winInterval"},{"Win claims per cycle","winClaims"},{"Win segment seconds","winBudgetSeconds"},{"Win cooldown seconds","winCooldown"},{"Action timeout seconds","actionTimeout"},{"Bed contact timeout","bedContactTimeout"},{"Failures before pause","maxFailures"},{"Retry backoff seconds","retryDelay"},{"Cycle delay seconds","cycleDelay"},{"Highest world","maxWorld"},{"Stop after cycles (0=off)","stopAfterCycles"}}local ed,ee={},{}for P,at in ipairs(ec)do table.insert(ed,at[1])ee[at[1]]=at[2]end;local ef={minBedSeconds="Minimum confirmed OnBed time per visit, at least 5 seconds. Auto funding and forced win trips use this minimum.",maxBedSeconds="Cap for normal XP-focused visits. Manual win timing can exceed this cap; Force uses the minimum instead.",etaMargin="Safety multiplier for the measured rebirth ETA when planning XP-focused bed visits. 1.15 adds a 15% margin.",winInterval="Active bed seconds before needed Manual win trips. Editing this selects Manual. Force uses the global minimum instead.",winClaims="Maximum confirmed free win claims in one segment. Auto can stop earlier once the planned upgrade is affordable.",winBudgetSeconds="Time budget for a win segment, checked between claims. An operation already started can finish its confirmation wait.",winCooldown="Wait between repeated win-pad claims. Keep at least 2 seconds; this does not control bed visit length.",actionTimeout="Maximum confirmation wait for a landing, reward, equipment change or travel. A pending server request pauses further actions.",bedContactTimeout="How long bed contact may be missing before the visit fails. Time away from the bed does not count as training.",maxFailures="Consecutive failures allowed before pausing Autofarm. A successful cycle clears the failure count.",retryDelay="Base delay before retrying an operation. The delay increases with consecutive failures.",cycleDelay="Pause between completed cycles. Does not replace pickup confirmation or win cooldown waits.",maxWorld="Highest world Autofarm may advance into. It moves forward through earned access; it does not travel backwards to this value.",stopAfterCycles="Stop after this many completed cycles. Set 0 to continue until you switch Autofarm off or it pauses on an error."}local eg={}for P,at in ipairs(ec)do eg[at[1]]=at[1].."\n"..ef[at[2]]end;local eh,ei,ej;eh=d7:Dropdown({name="Parameter to edit",options=ed,optionTooltips=eg,flag="af_parameter",scrollable=true,vis=5,callback=function()if e0 then e3()end end})ei=d7:Slider({name="Parameter value",min=5,max=60,def=cD.settings.minBedSeconds,flag="af_parameterValue",callback=function(Q)if e0 and not e1 then e4(ee[eh:Get()],Q)end end})ej=d7:Textbox({name="Exact parameter value",def=tostring(cD.settings.minBedSeconds),flag="af_exactParameter"})local function ek()local b1=eh:Get()return eg[b1].."\nChanging settings stops Autofarm."end;ei:SetTooltip(ek)ej:SetTooltip(ek)d7:Button({name="Apply parameter",callback=function()local Q=tonumber(ej:Get())if not Q then dO("Enter a numeric parameter value")return end;e4(ee[eh:Get()],Q)end})d7:Button({name="Preview plan (no actions)",callback=function()local el,m=bo.getAutofarmPlan()if not el then dO(m)return end;dO("World "..el.world.."; bed "..tostring(el.bed).."; win column "..tostring(el.winColumn).."; next world "..tostring(el.nextWorld or"locked / final"))end})d6:Button({name="Default settings",callback=function()bo.resetAutofarmSettings()e3()dO("Autofarm defaults restored; stopped")end})local em=dr(d7,{name="Progress",rows=6,options={"Stopped","World: - | Cycles: 0","Win claims: 0","Bed: 0 / 5s","XP/s: measuring","Rebirth ETA: measuring"},flag="af_status"})d7:Button({name="Show details",callback=function()local en=bo.getAutofarmStatus()dO(en.status..(en.lastError and" | "..en.lastError or"")..(en.winReason and" | "..en.winReason or"")..(en.pending and" | Waiting: "..en.pending or""))end})e3=function()e1=true;e6:Set(cD.enabled)for au,eo in pairs(e2)do eo:Set(cD.settings[au])end;e8:Set(cD.settings.bed)e9:Set(cD.settings.side)ea:Set(cD.settings.winTiming)eb:Set(cD.settings.winInterval)local au=ee[eh:Get()]or"minBedSeconds"local ep=cD.ranges[au]ei.min,ei.max,ei.dec=ep[1],ep[2],ep[3]ei:Set(cD.settings[au])ej:Set(tostring(cD.settings[au]))e1=false end;e0=true;e3()local eq=false;local er=dr(dd,{name="Current settings",options={"Loading..."},flag="settingsSummary"})local function es()return cE.toggleKey=="RightBracket"and"]"or cE.toggleKey end;local function et()if not eq or not l.alive then return end;cZ.watermark:SetText("Verity Jump Tower Destroyer  |  FPS: "..tostring(l.currentFPS or 0))cZ.watermark:SetVisible(cE.watermark)local du={"Toggle: "..es(),"Width: "..cE.width.." px","Height: "..cE.height.." px","Stats: "..cE.refreshInterval.."s","Anti idle: "..(l.antiIdleEnabled and"on"or"off")}if table.concat(er.options,"\n")~=table.concat(du,"\n")then er:Refresh(du)end end;local function eu()if eq and l.alive then cZ:Resize(Vector2.new(cE.width,cE.height))cZ.frame.Position=cP:RoundVector((workspace.CurrentCamera.ViewportSize-cZ.frame.Size)/2)et()end end;local ev=dc:Slider({name="Width",min=360,max=cR,def=cE.width,flag="uiWidth",suf=" px",callback=function(Q)cE.width=math.clamp(math.floor(Q),360,cR)eu()end})local ew=dc:Slider({name="Height",min=460,max=cS,def=cE.height,flag="uiHeight",suf=" px",callback=function(Q)cE.height=math.clamp(math.floor(Q),460,cS)eu()end})dc:Button({name="Bind show/hide key",callback=function()l.capturingToggleKey=true;dO("Press a key. Escape cancels.")end})dc:Button({name="Center window",callback=eu})local ex=dc:Slider({name="Stats refresh",min=1,max=5,def=cE.refreshInterval,flag="statsInterval",suf="s",callback=function(Q)cE.refreshInterval=math.clamp(math.floor(Q),1,5)et()end})local ey=dd:Toggle({name="Watermark",def=cE.watermark,flag="showWatermark",callback=function(Q)cE.watermark=Q;et()end})dc:Button({name="Reset settings",callback=function()l.capturingToggleKey=false;cE.toggleKey="RightBracket"ev:Set(cT)ew:Set(cU)ex:Set(1)ey:Set(true)et()end})local function ez(Q)if type(Q)=="number"and math.abs(Q)>=1e6 then return string.format("%.5g",Q)end;return tostring(Q)end;local function eA(ds,du,df)if#du==0 then du={"No data"}end;local eB=table.concat(du,"\n")if ds.rowSignature==eB then return end;local eC=table.find(ds.options,ds.value)or 1;if#du~=#ds.opinst then ds:Refresh(du)local function dA(dB,eD)for dD=#dB,1,-1 do if not eD(dB[dD])then table.remove(dB,dD)end end end;dA(df.instances,function(eE)return rawget(eE,"__OBJECT_EXIST")~=false end)for P,bw in ipairs(bu.drawings)do dA(bw,function(eE)return rawget(eE[1],"__OBJECT_EXIST")~=false end)end;for P,bw in pairs(bu.groups)do dA(bw,function(eE)return rawget(eE,"__OBJECT_EXIST")~=false end)end else ds.options=du;for dD,dy in ipairs(ds.opinst)do dy.Text=ds:fix_string(du[dD])end end;ds.value=du[math.min(eC,#du)]bu.flags[ds.flag]=ds.value;ds:update()ds.rowSignature=eB end;local function eF(eG,eH)if#eH==0 then eH={"Loading world pads..."}end;if table.concat(eG.options,"\n")==table.concat(eH,"\n")then return end;local aG=eG:Get()eG:Close()eG.visOptions=math.min(5,#eH)eG:Refresh(eH)eG:Set(table.find(eH,aG)and aG or eH[1])end;local function eI()if not l.alive then return end;l.padRefreshCount=(l.padRefreshCount or 0)+1;dk=a()di,dj={},{}local eH,a1={},{}for P,at in ipairs(aA()or{})do if not a1[at.rewardColumn]then local eJ="Col "..at.rewardColumn.." | lvl "..at.requiredLevel;a1[at.rewardColumn]=true;di[eJ]=at.rewardColumn;table.insert(eH,eJ)end end;eF(dm,eH)eH={}for P,at in ipairs(aR()or{})do local eK=at.equipped and"equipped"or at.owned and"owned"or"cost "..ez(at.cost)local eJ=at.name.." | "..eK;dj[eJ]=at.name;table.insert(eH,eJ)end;eF(dp,eH)local eL={}for P,at in ipairs(bf()or{})do table.insert(eL,at.tier)end;eF(dq,eL)l.padCatalogReady=next(di)~=nil and next(dj)~=nil;b8()end;local function eM(eN)if dl or not l.alive then return end;if cD.enabled then dO("Stop autofarm before manual teleports")return end;dl=true;local v,cy,cz=pcall(eN)dl=false;if not l.alive then return end;if not v then dO("Error: "..tostring(cy))elseif not cy then dO(cz or"No valid pad selected")else dO("Teleported to "..(cz.name or cz.tier or"column "..cz.rewardColumn.." "..cz.padType))end end;d0:Button({name="Teleport to win pad",callback=function()eM(function()local an=di[dm:Get()]if not an or dk==nil then return nil,"refresh_pad_list"end;return aD(an,{worldId=dk,padType=dn:Get(),side=aw:Get()~="Either"and aw:Get()or nil})end)end})d1:Button({name="Teleport / buy or equip",callback=function()eM(function()local b1=dj[dp:Get()]if not b1 or dk==nil then return nil,"refresh_pad_list"end;return b4(b1,{worldId=dk})end)end})d1:Button({name="Refresh pads",callback=function()X()eI()end})d2:Button({name="Teleport to owned bed",callback=function()eM(function()return bm(dq:Get(),{worldId=dk})end)end})d2:Button({name="Release teleport hold",callback=function()f()dO("Teleport hold released")end})d9:Button({name="Show full selected stat",callback=function()dO(dF:Get())end})da:Button({name="Unload interface",callback=function()l:Destroy()end})l.ui={winChoice=dm,jumpChoice=dp,bedChoice=dq,stats=dF,summary=dG,boxToggle=dJ,boxStatus=dK,boxChoice=dI,autoWinToggle=dL,autoUpgradeToggle=dM,movement={walkSlider=dS,jumpSlider=dT,walkText=dU,jumpText=dV,applyText=dY,sync=dX},autofarm={toggles=e2,bed=e8,side=e9,parameter=eh,runToggle=e6,winTiming=ea,winInterval=eb,setEnabled=function(bT)local eO=e1;e1=true;e6:Set(bT)e1=eO end,slider=ei,text=ej,status=em,refresh=e3,defaults=function()bo.resetAutofarmSettings()e3()end},refreshPads=function()X()eI()end,settings={width=ev,height=ew,interval=ex,watermark=ey}}cZ:Init()if not l.alive then bt(bu)return end;cZ.Unload=function()l:Destroy()end;eq=true;cL(cE.antiIdle)et()eI()local b=game:GetService("Players").LocalPlayer;local eP=b:GetAttribute("WorldId")local eQ=b:GetAttribute("WorldTravelSequence")local eR=false;for P,Z in ipairs({"WinPad","StepPad"})do local eS=game:GetService("CollectionService")table.insert(l.connections,eS:GetInstanceAddedSignal(Z):Connect(X))table.insert(l.connections,eS:GetInstanceRemovedSignal(Z):Connect(X))end;table.insert(l.connections,b:GetAttributeChangedSignal("EquippedStepPad"):Connect(function()eR=true end))for P,eT in ipairs({"WorldId","WorldTravelSequence","GroupReward","PassGoldBed","PassDiamondBed","PassObsidianBed"})do table.insert(l.connections,b:GetAttributeChangedSignal(eT):Connect(X))end;local function eU(a3)local b1=a3.Name;if b1=="WinPad"or b1=="Touch"or b1=="WinPads"or b1=="StepPads"or b1=="HeavenAssets"or b1=="EndAssets"or b1=="MinecraftPlaceholders_REPLACE"or b1:match("^World%d+$")or b1:match("^W%d+_Button%d+$")or b1:match("^Button%d+$")then X()end end;table.insert(l.connections,workspace.DescendantAdded:Connect(eU))table.insert(l.connections,workspace.DescendantRemoving:Connect(eU))local function eV()if d5.on and cZ.frame.Visible then local en=bo.getAutofarmStatus()eA(em,{en.enabled and en.phase or(en.lastError and"Paused (see details)"or"Stopped"),"World: "..tostring(a()or"-").." | Cycles: "..en.cycles,"Win claims: "..en.confirmedWins,string.format("Bed: %.1f / %.1fs",en.activeBedSeconds or 0,en.plannedBedSeconds or cD.settings.minBedSeconds),"XP/s: "..(en.rate and string.format("%.3g",en.rate)or"measuring"),"Rebirth ETA: "..(en.eta and(en.eta>=3600 and string.format("%.1fh",en.eta/3600)or en.eta>=60 and string.format("%.1fm",en.eta/60)or string.format("%.0fs",en.eta))or"measuring")},d7)end;if c_.on and cZ.frame.Visible then eA(dK,{l.boxCaptureStatus or"Stopped","Captured: "..tostring(l.boxCaptureCollected or 0)},d3)end;if not d8.on or not cZ.frame.Visible then return end;local eW=b:GetAttributes()local du={}for au,Q in pairs(eW)do table.insert(du,au.." = "..tostring(Q))end;local eX=b:FindFirstChild("leaderstats")if eX then for P,Q in ipairs(eX:GetChildren())do if Q:IsA("ValueBase")then table.insert(du,"leaderstats."..Q.Name.." = "..tostring(Q.Value))end end end;local o=b.Character;local q=o and o:FindFirstChildOfClass("Humanoid")if q then for P,au in ipairs({"Health","MaxHealth","WalkSpeed","JumpPower","JumpHeight","UseJumpPower"})do table.insert(du,"Humanoid."..au.." = "..tostring(q[au]))end end;if o then for au,Q in pairs(o:GetAttributes())do table.insert(du,"character."..au.." = "..tostring(Q))end end;table.sort(du)eA(dF,du,d9)local bh=b:GetAttribute("PassWinsX2")local eY=bh==true and"Owned"or bh==false and"Not owned"or"Loading"eA(dG,{"Current world: "..tostring(a()or"Loading"),"2x wins pass: "..eY,"Jump pad: "..tostring(eW.EquippedStepPad or"None"),"Level: "..ez(eW.Level),"Wins: "..ez(eW.Wins),"Status: "..dN,es()..": show/hide | scroll over stats","Pad automation: "..tostring(l.padAutoStatus or"Ready"),"Anti idle: "..(l.idleLastError and"input unavailable"or l.antiIdleEnabled and"on"or"off"),"Unowned jump pads spend their displayed wins.","Full current-world pad catalog; auto streaming.","No reward is guaranteed by teleporting.","Updates every second."},da)for dD=#bu.connections,1,-1 do if bu.connections[dD].Connected==false then table.remove(bu.connections,dD)end end end;eV()local F=0;local eZ,e_,f0=0,0,0;table.insert(l.connections,game:GetService("RunService").RenderStepped:Connect(function(I)e_,f0=e_+I,f0+1;if e_>=0.5 then l.currentFPS=math.floor(f0/e_+0.5)e_,f0=0,0;if l.alive then cZ.watermark:SetText("Verity Jump Tower Destroyer  |  FPS: "..l.currentFPS)end end end))table.insert(l.connections,game:GetService("RunService").Heartbeat:Connect(function(I)if not l.alive then return end;F=F+I;eZ=eZ+I;if eZ>=0.5 and(eR or l.padsDirty or not l.padCatalogReady and eZ>=3)then eZ=0;eR,l.padsDirty=false,false;local v,bY=pcall(eI)if not v then dN="Pad refresh: "..tostring(bY)end end;if F>=cE.refreshInterval then F=0;local v,bY=pcall(eV)if not v then dN="Refresh failed: "..tostring(bY)end end end))l.handleToggleInput=function(f1,f2)if not l.alive or f2 or f1.UserInputType~=Enum.UserInputType.Keyboard then return end;if bs:GetFocusedTextBox()or cZ.shit.textbox then return end;if l.capturingToggleKey then l.capturingToggleKey=false;if f1.KeyCode==Enum.KeyCode.Escape then dO("Key binding cancelled.")return end;if f1.KeyCode==Enum.KeyCode.Unknown then return end;cE.toggleKey=f1.KeyCode.Name;et()dO("Show/hide key: "..es())return end;if f1.KeyCode.Name==cE.toggleKey then cZ:Fade()end end;table.insert(l.connections,bs.InputBegan:Connect(l.handleToggleInput))bo.refreshPads=function()X()eI()end end;local f3=coroutine.running()table.insert(l.tasks,f3)local f4,f5=xpcall(cM,debug.traceback)local f6=table.find(l.tasks,f3)if f6 then table.remove(l.tasks,f6)end;if not f4 then local f7,f8=pcall(l.Destroy,l)error("Verity interface failed to initialize: "..tostring(f5)..(f7 and""or"\nCleanup also failed: "..tostring(f8)))end;return bo
