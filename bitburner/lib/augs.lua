local augs = {}

local function Augs(defaults)
  return function(list)
    for k,v in pairs(list) do
      if type(v) == 'string' then
        augs[v] = setmetatable({name=v}, {__index=defaults})
      else
        augs[v.name] = setmetatable(v, {__index=defaults})
      end
    end
  end
end

Augs { type='hacknet'; priority=4; } {
  "Hacknet Node CPU Architecture Neural-Upload",
  "Hacknet Node Cache Architecture Neural-Upload",
  "Hacknet Node NIC Architecture Neural-Upload",
  "Hacknet Node Kernel Direct-Neural Interface",
  "Hacknet Node Core Direct-Neural Interface",
}

Augs { type='hack'; priority=1; } {
  { name="BitRunners Neurolink"; priority=10; };
  { name="CashRoot Starter Kit"; priority=10; };
  { name="Neuralstimulator"; priority=0; };
  "CRTX42-AA Gene Modification",
  { name="Neuregen Gene Modification", priority=2 };
  "BitWire",
  "Artificial Bio-neural Network Implant",
  "Artificial Synaptic Potentiation",
  "Enhanced Myelin Sheathing",
  "Synaptic Enhancement Implant",
  "Neural-Retention Enhancement",
  "DataJack",
  "Embedded Netburner Module",
  "Embedded Netburner Module Core Implant",
  "Embedded Netburner Module Core V2 Upgrade",
  "Embedded Netburner Module Core V3 Upgrade",
  "Embedded Netburner Module Analyze Engine",
  "Embedded Netburner Module Direct Memory Access Upgrade",
  "Neural Accelerator",
  "Cranial Signal Processors - Gen I",
  "Cranial Signal Processors - Gen II",
  "Cranial Signal Processors - Gen III",
  "Cranial Signal Processors - Gen IV",
  "Cranial Signal Processors - Gen V",
  "Neuronal Densification",
  "PC Direct-Neural Interface",
  "PC Direct-Neural Interface Optimization Submodule",
  "PC Direct-Neural Interface NeuroNet Injector",
  "HyperSight Corneal Implant",
  "QLink",
  "OmniTek InfoLoad",
  "The Black Hand",
}

Augs { type='social/corp'; priority=1; } {
  "Enhanced Social Interaction Implant",
  "Speech Processor Implant",
  "TITN-41 Gene-Modification Injection",
  "Nuoptimal Nootropic Injector Implant",
  "Speech Enhancement",
  "FocusWire",
}

Augs { type='social'; priority=1; } {
  "ADR-V1 Pheromone Gene",
  "ADR-V2 Pheromone Gene",
  "SmartJaw",
  "Social Negotiation Assistant (S.N.A)",
}

Augs { type='combat'; priority=-1; } {
  "Augmented Targeting I",
  "Augmented Targeting II",
  "Augmented Targeting III",
  "Synthetic Heart",
  "Synfibril Muscle",
  "Combat Rib I",
  "Combat Rib II",
  "Combat Rib III",
  "Nanofiber Weave",
  "NEMEAN Subdermal Weave",
  "Wired Reflexes",
  "Graphene Bone Lacings",
  "Bionic Spine",
  "Graphene Bionic Spine Upgrade",
  "Bionic Legs",
  "Graphene Bionic Legs Upgrade",
  "LuminCloaking-V1 Skin Implant",
  "LuminCloaking-V2 Skin Implant",
  "HemoRecirculator",
  "SmartSonar Implant",
  "CordiARC Fusion Reactor",
  "Neotra",
  "Photosynthetic Cells",
  "NutriGen Implant",
  "INFRARET Enhancement",
  "DermaForce Particle Barrier",
}

Augs { type='special'; priority=1 } {
  { name="NeuroFlux Governor"; priority=-999 }; -- special cased in autofaction.lua
  { name="The Red Pill"; priority=1000; };
  "Neurotrainer I",
  "Neurotrainer II",
  "Neurotrainer III",
  "Power Recirculation Core",
  "SPTN-97 Gene Modification",
  "ECorp HVMind Implant",
  "Xanipher",
  "nextSENS Gene Modification",
}

return augs
