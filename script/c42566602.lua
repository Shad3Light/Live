--Scripted by Eerie Code
--Coral Dragon
function c42566602.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(42566602,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1)
  e1:SetCost(c42566602.cost)
  e1:SetTarget(c42566602.target)
  e1:SetOperation(c42566602.operation)
  c:RegisterEffect(e1)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(42566602,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,42566602)
	e4:SetCondition(c42566602.drcon)
	e4:SetTarget(c42566602.drtg)
	e4:SetOperation(c42566602.drop)
	c:RegisterEffect(e4)
end

function c42566602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c42566602.filter(c)
	return c:IsDestructable()
end
function c42566602.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c42566602.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c42566602.filter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c42566602.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c42566602.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
  end
end

function c42566602.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO 
end
function c42566602.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c42566602.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end