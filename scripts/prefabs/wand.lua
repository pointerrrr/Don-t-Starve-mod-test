local assets=
{ 
    Asset("ANIM", "anim/wand.zip"),
    Asset("ANIM", "anim/swap_wand.zip"), 

    Asset("ATLAS", "images/inventoryimages/wand.xml"),
    Asset("IMAGE", "images/inventoryimages/wand.tex"),
    
}

local prefabs = 
{
"explode_small"
}

local function attack(inst,target, pos)
    local explode = SpawnPrefab("explode_small")
    
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
    
    if target ~= nil then
        pos = target:GetPosition()
    end
    
    explode.Transform:SetPosition(pos.x, pos.y, pos.z) 
    local bomb = CreateEntity()
    local trans = bomb.entity:AddTransform()
    local anim = bomb.entity:AddAnimState()
    
    
    bomb:AddComponent("explosive")
    bomb.Transform:SetPosition(pos.x, pos.y, pos.z)
    bomb.components.explosive:OnBurnt()
end

local function canteleport(inst, caster, target)
    --if target then
      --  return target.components.locomotor ~= nil
    --end

    return true
end

local function fn()

    local function OnEquip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_wand", "wand")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local function OnUnequip(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("wand")
    anim:SetBuild("wand")
    anim:PlayAnimation("idle")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "wand"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wand.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	--inst:AddComponent("weapon")
    --inst.components.weapon:SetDamage(0)
	--inst.components.weapon:SetOnAttack(attack)
	--inst.components.weapon:SetRange(8, 10)
    
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(attack)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    --inst.components.spellcaster:SetSpellTestFn(function(a) return true end)

    return inst
end

return  Prefab("common/inventory/wand", fn, assets, prefabs)