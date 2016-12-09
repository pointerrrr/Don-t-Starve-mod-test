local assets=
{ 
    Asset("ANIM", "anim/wand.zip"),
    Asset("ANIM", "anim/swap_wand.zip"), 

    Asset("ATLAS", "images/inventoryimages/wand.xml"),
    Asset("IMAGE", "images/inventoryimages/wand.tex"),
}

local prefabs = 
{
}

local function attack(inst,attacker,target)
	--if target.components.combat then target.components.combat:SuggestTarget(attacker)
        if target.sg and not target.sg:HasStateTag("frozen") then
            target.sg:GoToState("hit")
			local pt = Input:GetWorldPosition()		
			local explode = SpawnPrefab("explode_small")
			--explode.explosiverange = 100
			--pt = Vector3(GetWorld().Map:GetTileCenterPoint(pt:Get()))
			--explode.Transform:SetPosition(pt:Get())
			explode.Transform:SetPosition(target.Transform:GetWorldPosition())
			explode.explosivedamage = 100
			--explode.Transform:SetPosition(pt:Get())	
		end
	--end
end

local function fn()

    local function OnEquip(inst, owner) 
        --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
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
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	inst.components.weapon:SetOnAttack(attack)
	inst.components.weapon:SetRange(8, 10)

    return inst
end

return  Prefab("common/inventory/wand", fn, assets, prefabs)