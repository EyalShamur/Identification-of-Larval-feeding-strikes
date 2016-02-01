function [desc] = stack_descriptors(stack_option, mbh_decision_values, mip_decision_values, stip_decision_values, vif_decision_values)


         
            
    stacking___mip_mbh = [mip_decision_values mbh_decision_values];
    stacking___mip_mbh_vif = [mip_decision_values mbh_decision_values vif_decision_values];
    stacking___mip_mbh_stip = [mip_decision_values mbh_decision_values stip_decision_values];
    stacking___mbh_stip = [mbh_decision_values stip_decision_values];
    stacking___mip_stip = [mip_decision_values  stip_decision_values];
    stacking___mbh_vif = [mbh_decision_values vif_decision_values];
    stacking___mip_vif = [mip_decision_values  vif_decision_values];
    stacking___mbh_mip_stip_vif = [mbh_decision_values mip_decision_values stip_decision_values vif_decision_values];
    stacking___mbh_mip_vif = [mbh_decision_values mip_decision_values  vif_decision_values];
    desc = stacking___mip_mbh_stip;


    switch stack_option
        case 'MBH+VIF'
            desc = stacking___mbh_vif;
            
        case 'MBH+MIP'
            desc = stacking___mip_mbh; 
            
        case 'STIP+MIP+MBH'
            desc = stacking___mip_mbh_stip;
                  
        case 'MIP+MBH+VIF'
            desc = stacking___mip_mbh_vif;
                   
        case 'STIP+MIP+MBH+VIF'
            desc = stacking___mbh_mip_stip_vif;
                   
    end
    
                           

            




end

