// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interface/IHeroGene.sol";
import "./base/RNGCallerBase.sol";
import "./utils/Integers.sol";
import "./utils/ExStrings.sol";
import "./HeroGeneShowSkill.sol";

contract HeroGene is IHeroGene, RNGCallerBase {
    using ExStrings for string;
    using Integers for uint256;

    // bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    address _HeroGeneShowSkillContract;

    bool HasData;
    uint[] RandIntList;
    uint index;

    /* modifier onlyMinter() {
        _checkRole(MINTER_ROLE, msg.sender);
        _;
    } */
    function setHeroGeneShowSkillContract(address addr) public{
        _HeroGeneShowSkillContract = addr;
    }

    constructor() {
    }

    function _checkRNGModifier(address caller) internal virtual override {
        // _checkRole(MINTER_ROLE, caller);
    }

    function parseIntSelf(string memory s) private pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) {
            if (uint(uint8(b[i])) >= 48 && uint(uint8(b[i])) <= 57) {
                result = result * 10 + (uint(uint8(b[i])) - 48);
            }
        }
        return result;
    }

    function get_rand_int(uint x, uint step, address owner) internal returns(uint mold){
        if (x == 0) {
            return step;
        }
        if (HasData == false) {
            // RandIntList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
            RandIntList = _expandRandomness(owner, 25);
            HasData = true;
        }
        uint v = RandIntList[index];
        mold = v%(x) + step;
        if (index == 24){
            HasData = false;
            index = 0;
        }
        index = index + 1;
    }

    struct ParentADNA{
        string batchA;
        string unitA;
        string campA;
        string attrA;
        string showA;
        string skillA;
        string showA_r1;
        string skillA_r1;
        string showA_r2;
        string skillA_r2;
    }

    struct ParentBDNA{
        string batchB;
        string unitB;
        string campB;
        string attrB;
        string showB;
        string skillB;
        string showB_r1;
        string skillB_r1;
        string showB_r2;
        string skillB_r2;
    }

    struct BornDNAInfo{
        string batchC;
        string unitC;
        string campC;
        string attrC;
        string showC;
        string skillC;
        string showC_r1;
        string skillC_r1;
        string showC_r2;
        string skillC_r2;
    }

    struct Attr{
        uint attrA_health;
        uint attrA_speed;
        uint attrA_skill;
        uint attrA_mood;
        uint attrB_health;
        uint attrB_speed;
        uint attrB_skill;
        uint attrB_mood;
        uint attrC_health;
        uint attrC_speed;
        uint attrC_skill;
        uint attrC_mood;
    }

    // struct InfoAData {
    //     string showA_head;
    //     string showA_hand;
    //     string showA_body;
    //     string showA_weapon;
    //     string showA_platform;
    //     string showA_flag;
    //     string skillA_head;
    //     string skillA_hand;
    //     string skillA_body;
    //     string skillA_weapon;
    // }

    // struct InfoBData {
    //     string showB_head;
    //     string showB_hand;
    //     string showB_body;
    //     string showB_weapon;
    //     string showB_platform;
    //     string showB_flag;
    //     string skillB_head;
    //     string skillB_hand;
    //     string skillB_body;
    //     string skillB_weapon;
    // }

    // struct InfoAR1Data {
    //     string showA_r1_head;
    //     string showA_r1_hand;
    //     string showA_r1_body;
    //     string showA_r1_weapon;
    //     string showA_r1_platform;
    //     string showA_r1_flag;
    //     string skillA_r1_head;
    //     string skillA_r1_hand;
    //     string skillA_r1_body;
    //     string skillA_r1_weapon;
    // }

    // struct InfoBR1Data {
    //     string showB_r1_head;
    //     string showB_r1_hand;
    //     string showB_r1_body;
    //     string showB_r1_weapon;
    //     string showB_r1_platform;
    //     string showB_r1_flag;
    //     string skillB_r1_head;
    //     string skillB_r1_hand;
    //     string skillB_r1_body;
    //     string skillB_r1_weapon;
    // }

    // struct InfoAR2Data {
    //     string showA_r2_head;
    //     string showA_r2_hand;
    //     string showA_r2_body;
    //     string showA_r2_weapon;
    //     string showA_r2_platform;
    //     string showA_r2_flag;
    //     string skillA_r2_head;
    //     string skillA_r2_hand;
    //     string skillA_r2_body;
    //     string skillA_r2_weapon;
    // }

    // struct InfoBR2Data {
    //     string showB_r2_head;
    //     string showB_r2_hand;
    //     string showB_r2_body;
    //     string showB_r2_weapon;
    //     string showB_r2_platform;
    //     string showB_r2_flag;
    //     string skillB_r2_head;
    //     string skillB_r2_hand;
    //     string skillB_r2_body;
    //     string skillB_r2_weapon;
    // }

    // struct BornDnaData {
    //     string show_head;
    //     string show_hand;
    //     string show_body;
    //     string show_weapon;
    //     string show_platform;
    //     string show_flag;
    //     string skill_head;
    //     string skill_hand;
    //     string skill_body;
    //     string skill_weapon;

    //     string show_r1_head;
    //     string show_r1_hand;
    //     string show_r1_body;
    //     string show_r1_weapon;
    //     string show_r1_platform;
    //     string show_r1_flag;
    //     string skill_r1_head;
    //     string skill_r1_hand;
    //     string skill_r1_body;
    //     string skill_r1_weapon;

    //     string show_r2_head;
    //     string show_r2_hand;
    //     string show_r2_body;
    //     string show_r2_weapon;
    //     string show_r2_platform;
    //     string show_r2_flag;
    //     string skill_r2_head;
    //     string skill_r2_hand;
    //     string skill_r2_body;
    //     string skill_r2_weapon;

    //     string showC;
    //     string skillC;
    //     string showC_r1;
    //     string skillC_r1;
    //     string showC_r2;
    //     string skillC_r2;
    // }

    // struct ShowCResData{
    //     string[4] showC_head_res;
    //     string[4] showC_hand_res;
    //     string[4] showC_body_res;
    //     string[4] showC_weapon_res;
    //     string[2] showC_platform_res;
    //     string[2] showC_flag_res;
    // }

    function get_unit(string memory unitA, string memory unitB, address owner, uint256 limit) internal returns(string memory){
        uint r = get_rand_int(100000, 1, owner);
        if (r <= limit) {
            return unitA;
        } else {
            return unitB;
        }
    }

    function get_camp(string memory campA, string memory campB, address owner) internal returns(string memory){
        uint r = get_rand_int(100000, 1, owner);
        if (r <= 50000) {
            return campA;
        } else {
            return campB;
        }
    }

    function get_attr(string memory attrA, string memory attrB) internal pure returns(string memory res){
        Attr memory attr;
        attr.attrA_health = parseIntSelf(attrA._substring(2, 0));
        attr.attrA_speed = parseIntSelf(attrA._substring(2, 2));
        attr.attrA_skill = parseIntSelf(attrA._substring(2, 4));
        attr.attrA_mood = parseIntSelf(attrA._substring(2, 6));
        attr.attrB_health = parseIntSelf(attrB._substring(2, 0));
        attr.attrB_speed = parseIntSelf(attrB._substring(2, 2));
        attr.attrB_skill = parseIntSelf(attrB._substring(2, 4));
        attr.attrB_mood = parseIntSelf(attrB._substring(2, 6));

        attr.attrC_health = (attr.attrA_health + attr.attrB_health)/2;
        attr.attrC_speed = (attr.attrA_speed + attr.attrB_speed)/2;
        attr.attrC_skill = (attr.attrA_skill + attr.attrB_skill)/2;
        attr.attrC_mood = (attr.attrA_mood + attr.attrB_mood)/2;
        uint attr_total = attr.attrC_health + attr.attrC_speed + attr.attrC_skill + attr.attrC_mood;
        uint add = 140 - attr_total;
        while (add > 0) {
            add = add - 1;
            if (attr.attrC_health < 43) {
                attr.attrC_health = attr.attrC_health + 1;
                continue;
            }
            if (attr.attrC_speed < 43) {
                attr.attrC_speed = attr.attrC_speed + 1;
                continue;
            }
            if (attr.attrC_skill < 43) {
                attr.attrC_skill = attr.attrC_skill + 1;
                continue;
            }          
            if (attr.attrC_mood < 43) {
                attr.attrC_mood = attr.attrC_mood + 1;
                continue;
            }
        }
        res = Integers.toString(attr.attrC_health);
        res = res.concat(Integers.toString(attr.attrC_speed));
        res = res.concat(Integers.toString(attr.attrC_skill));
        res = res.concat(Integers.toString(attr.attrC_mood));
        return res;
    }

    // function legend_to_normal(string memory s) internal pure returns(string memory){
    //     if (s.compareTo("51")){
    //         return "11";
    //     }
    //     if (s.compareTo("61")){
    //         return "21";
    //     }
    //     if (s.compareTo("71")){
    //         return "31";
    //     }
    //     if (s.compareTo("81")){
    //         return "41";
    //     }
    //     return s;
    // }

    // function get_showC_skill(string[12] memory list_skill, address owner) internal returns(string[2] memory){
    //     // 1~37500 A;37501~75000 B;75001 ~ 84375 A_r1;84376~93750 B_r1;93751~96875 A_r2;96876~100000 B_r2
    //     string memory showC_ = "";
    //     string memory skillC_ = "";
    //     uint r = get_rand_int(100000, 1, owner);
    //     if (r <= 37500){
    //         showC_ = list_skill[0];
    //         skillC_ = list_skill[1];
    //     }
    //     if (r>37501 && r<=75000){
    //         showC_ = list_skill[2];
    //         skillC_ = list_skill[3];
    //     }
    //     if (r>75001 && r<=84375){
    //         showC_ = list_skill[4];
    //         skillC_ = list_skill[5];
    //     }
    //     if (r>84376 && r<=93750){
    //         showC_ = list_skill[6];
    //         skillC_ = list_skill[7];
    //     }
    //     if (r>93751 && r<=96875){
    //         showC_ = list_skill[8];
    //         skillC_ = list_skill[9];
    //     }
    //     if (r>96876 && r<=100000){
    //         showC_ = list_skill[10];
    //         skillC_ = list_skill[11];
    //     }
    //     return [showC_, skillC_];
    // }

    // function get_showC_platform_or_flag(string[6] memory pre_platform, address owner) internal returns(string memory){
    //     // 1~37500 A;37501~75000 B;75001 ~ 84375 A_r1;84376~93750 B_r1;93751~96875 A_r2;96876~100000 B_r2
    //     string memory showC_platform_or_flog = "";
    //     uint r = get_rand_int(100000, 1, owner);
    //     if (r <= 37500){
    //         showC_platform_or_flog = pre_platform[0];
    //     } else if (r>37501 && r<=75000){
    //         showC_platform_or_flog = pre_platform[1];
    //     } else if (r>75001 && r<=84375){
    //         showC_platform_or_flog = pre_platform[2];
    //     } else if (r>84376 && r<=93750){
    //         showC_platform_or_flog = pre_platform[3];
    //     } else if (r>93751 && r<=96875){
    //         showC_platform_or_flog = pre_platform[4];
    //     } else if (r>96876 && r<=100000){
    //         showC_platform_or_flog = pre_platform[5];
    //     }
    //     return showC_platform_or_flog;
    // }

    // function get_C_r1_r2(string[6] memory list_show, string[6] memory list_skill,
    //                     string memory showC_check) internal pure returns(string[4] memory) {
    //     uint i = 0;
    //     uint j = 0;
    //     while (showC_check.compareTo(list_show[i]) && i < 5){
    //         i = i + 1;
    //     }
    //     while ((showC_check.compareTo(list_show[j]) || (list_show[i].compareTo(list_show[j]))) && (j < 5)){
    //         j = j + 1;
    //     }
    //     return [list_show[i], list_skill[i], list_show[j], list_skill[j]];
    // }

    // function get_showC_r1_r2_platform_or_flag(string[6] memory list_show_platform_or_flag,
    //                                     string memory showC_platform_or_flag) internal pure returns(string[2] memory) {
                                    
    //     uint i = 0;
    //     uint j = 0;
    //     while (showC_platform_or_flag.compareTo(list_show_platform_or_flag[i])  && i < 5){
    //         i = i + 1;
    //     }
    //     while (((showC_platform_or_flag.compareTo(list_show_platform_or_flag[j])) || 
    //     (list_show_platform_or_flag[i].compareTo(list_show_platform_or_flag[j]))) && (j < 5)){
    //         j = j + 1;
    //     }
    //     return [list_show_platform_or_flag[i], list_show_platform_or_flag[j]];
    // }

    // function get_show_skill(string[12] memory per_show_skill, address owner) internal returns(string[6] memory){
    //     InfoAData memory InfoA;
    //     InfoBData memory InfoB;
    //     InfoAR1Data memory InfoAR1;
    //     InfoBR1Data memory InfoBR1;
    //     InfoAR2Data memory InfoAR2;
    //     InfoBR2Data memory InfoBR2;
    //     BornDnaData memory BornDNA;
    //     ShowCResData memory ShowCRes;

    //     // show skill
    //     InfoA.showA_head = per_show_skill[0]._substring(2, 0);
    //     InfoA.showA_hand = per_show_skill[0]._substring(2, 2);
    //     InfoA.showA_body = per_show_skill[0]._substring(2, 4);
    //     InfoA.showA_weapon = per_show_skill[0]._substring(2, 6);
    //     InfoA.showA_platform = per_show_skill[0]._substring(2, 8);
    //     InfoA.showA_flag = per_show_skill[0]._substring(2, 10);
    //     InfoA.showA_head = legend_to_normal(InfoA.showA_head);
    //     InfoA.showA_hand = legend_to_normal(InfoA.showA_hand);
    //     InfoA.showA_body = legend_to_normal(InfoA.showA_body);
    //     InfoA.showA_weapon = legend_to_normal(InfoA.showA_weapon);

    //     InfoA.skillA_head = per_show_skill[1]._substring(2, 0);
    //     InfoA.skillA_hand = per_show_skill[1]._substring(2, 2);
    //     InfoA.skillA_body = per_show_skill[1]._substring(2, 4);
    //     InfoA.skillA_weapon = per_show_skill[1]._substring(2, 6);

    //     InfoB.showB_head = per_show_skill[2]._substring(2, 0);
    //     InfoB.showB_hand = per_show_skill[2]._substring(2, 2);
    //     InfoB.showB_body = per_show_skill[2]._substring(2, 4);
    //     InfoB.showB_weapon = per_show_skill[2]._substring(2, 6);
    //     InfoB.showB_platform = per_show_skill[2]._substring(2, 8);
    //     InfoB.showB_flag = per_show_skill[2]._substring(2, 10);
    //     InfoB.showB_head = legend_to_normal(InfoB.showB_head);
    //     InfoB.showB_hand = legend_to_normal(InfoB.showB_hand);
    //     InfoB.showB_body = legend_to_normal(InfoB.showB_body);
    //     InfoB.showB_weapon = legend_to_normal(InfoB.showB_weapon);

    //     InfoB.skillB_head = per_show_skill[3]._substring(2, 0);
    //     InfoB.skillB_hand = per_show_skill[3]._substring(2, 2);
    //     InfoB.skillB_body = per_show_skill[3]._substring(2, 4);
    //     InfoB.skillB_weapon = per_show_skill[3]._substring(2, 6);

    //     // r1 show skill
    //     InfoAR1.showA_r1_head = per_show_skill[4]._substring(2, 0);
    //     InfoAR1.showA_r1_hand = per_show_skill[4]._substring(2, 2);
    //     InfoAR1.showA_r1_body = per_show_skill[4]._substring(2, 4);
    //     InfoAR1.showA_r1_weapon = per_show_skill[4]._substring(2, 6);
    //     InfoAR1.showA_r1_platform = per_show_skill[4]._substring(2, 8);
    //     InfoAR1.showA_r1_flag = per_show_skill[4]._substring(2, 10);
    //     InfoAR1.showA_r1_head = legend_to_normal(InfoAR1.showA_r1_head);
    //     InfoAR1.showA_r1_hand = legend_to_normal(InfoAR1.showA_r1_hand);
    //     InfoAR1.showA_r1_body = legend_to_normal(InfoAR1.showA_r1_body);
    //     InfoAR1.showA_r1_weapon = legend_to_normal(InfoAR1.showA_r1_weapon);

    //     InfoAR1.skillA_r1_head = per_show_skill[5]._substring(2, 0);
    //     InfoAR1.skillA_r1_hand = per_show_skill[5]._substring(2, 2);
    //     InfoAR1.skillA_r1_body = per_show_skill[5]._substring(2, 4);
    //     InfoAR1.skillA_r1_weapon = per_show_skill[5]._substring(2, 6);

    //     InfoBR1.showB_r1_head = per_show_skill[6]._substring(2, 0);
    //     InfoBR1.showB_r1_hand = per_show_skill[6]._substring(2, 2);
    //     InfoBR1.showB_r1_body = per_show_skill[6]._substring(2, 4);
    //     InfoBR1.showB_r1_weapon = per_show_skill[6]._substring(2, 6);
    //     InfoBR1.showB_r1_platform = per_show_skill[6]._substring(2, 8);
    //     InfoBR1.showB_r1_flag = per_show_skill[6]._substring(2, 10);
    //     InfoBR1.showB_r1_head = legend_to_normal(InfoBR1.showB_r1_head);
    //     InfoBR1.showB_r1_hand = legend_to_normal(InfoBR1.showB_r1_hand);
    //     InfoBR1.showB_r1_body = legend_to_normal(InfoBR1.showB_r1_body);
    //     InfoBR1.showB_r1_weapon = legend_to_normal(InfoBR1.showB_r1_weapon);

    //     InfoBR1.skillB_r1_head = per_show_skill[7]._substring(2, 0);
    //     InfoBR1.skillB_r1_hand = per_show_skill[7]._substring(2, 2);
    //     InfoBR1.skillB_r1_body = per_show_skill[7]._substring(2, 4);
    //     InfoBR1.skillB_r1_weapon = per_show_skill[7]._substring(2, 6);

    //     // r2 show skill
    //     InfoAR2.showA_r2_head = per_show_skill[8]._substring(2, 0);
    //     InfoAR2.showA_r2_hand = per_show_skill[8]._substring(2, 2);
    //     InfoAR2.showA_r2_body = per_show_skill[8]._substring(2, 4);
    //     InfoAR2.showA_r2_weapon = per_show_skill[8]._substring(2, 6);
    //     InfoAR2.showA_r2_platform = per_show_skill[8]._substring(2, 8);
    //     InfoAR2.showA_r2_flag = per_show_skill[8]._substring(2, 10);
    //     InfoAR2.showA_r2_head = legend_to_normal(InfoAR2.showA_r2_head);
    //     InfoAR2.showA_r2_hand = legend_to_normal(InfoAR2.showA_r2_hand);
    //     InfoAR2.showA_r2_body = legend_to_normal(InfoAR2.showA_r2_body);
    //     InfoAR2.showA_r2_weapon = legend_to_normal(InfoAR2.showA_r2_weapon);

    //     InfoAR2.skillA_r2_head = per_show_skill[9]._substring(2, 0);
    //     InfoAR2.skillA_r2_hand = per_show_skill[9]._substring(2, 2);
    //     InfoAR2.skillA_r2_body = per_show_skill[9]._substring(2, 4);
    //     InfoAR2.skillA_r2_weapon = per_show_skill[9]._substring(2, 6);

    //     InfoBR2.showB_r2_head = per_show_skill[10]._substring(2, 0);
    //     InfoBR2.showB_r2_hand = per_show_skill[10]._substring(2, 2);
    //     InfoBR2.showB_r2_body = per_show_skill[10]._substring(2, 4);
    //     InfoBR2.showB_r2_weapon = per_show_skill[10]._substring(2, 6);
    //     InfoBR2.showB_r2_platform = per_show_skill[10]._substring(2, 8);
    //     InfoBR2.showB_r2_flag = per_show_skill[10]._substring(2, 10);
    //     InfoBR2.showB_r2_head = legend_to_normal(InfoBR2.showB_r2_head);
    //     InfoBR2.showB_r2_hand = legend_to_normal(InfoBR2.showB_r2_hand);
    //     InfoBR2.showB_r2_body = legend_to_normal(InfoBR2.showB_r2_body);
    //     InfoBR2.showB_r2_weapon = legend_to_normal(InfoBR2.showB_r2_weapon);

    //     InfoBR2.skillB_r2_head = per_show_skill[11]._substring(2, 0);
    //     InfoBR2.skillB_r2_hand = per_show_skill[11]._substring(2, 2);
    //     InfoBR2.skillB_r2_body = per_show_skill[11]._substring(2, 4);
    //     InfoBR2.skillB_r2_weapon = per_show_skill[11]._substring(2, 6);

    //     string[2] memory showC_skill_head = get_showC_skill([InfoA.showA_head, InfoA.skillA_head, InfoB.showB_head, InfoB.skillB_head,
    //                                             InfoAR1.showA_r1_head, InfoAR1.skillA_r1_head, InfoBR1.showB_r1_head, InfoBR1.skillB_r1_head,
    //                                             InfoAR2.showA_r2_head, InfoAR2.skillA_r2_head, InfoBR2.showB_r2_head, InfoBR2.skillB_r2_head], owner);   
    //     BornDNA.show_head = showC_skill_head[0];
    //     BornDNA.skill_head = showC_skill_head[1];
    //     string[2] memory showC_skill_hand = get_showC_skill([InfoA.showA_hand, InfoA.skillA_hand, InfoB.showB_hand, InfoB.skillB_hand,
    //                                             InfoAR1.showA_r1_hand, InfoAR1.skillA_r1_hand, InfoBR1.showB_r1_hand, InfoBR1.skillB_r1_hand,
    //                                             InfoAR2.showA_r2_hand, InfoAR2.skillA_r2_hand, InfoBR2.showB_r2_hand, InfoBR2.skillB_r2_hand], owner);   
    //     BornDNA.show_hand = showC_skill_hand[0];
    //     BornDNA.skill_hand = showC_skill_hand[1];
    //     string[2] memory showC_skill_body = get_showC_skill([InfoA.showA_body, InfoA.skillA_body, InfoB.showB_body, InfoB.skillB_body,
    //                                             InfoAR1.showA_r1_body, InfoAR1.skillA_r1_body, InfoBR1.showB_r1_body, InfoBR1.skillB_r1_body,
    //                                             InfoAR2.showA_r2_body, InfoAR2.skillA_r2_body, InfoBR2.showB_r2_body, InfoBR2.skillB_r2_body], owner);   
    //     BornDNA.show_body = showC_skill_body[0];
    //     BornDNA.skill_body = showC_skill_body[1];
    //     string[2] memory showC_skill_weapon = get_showC_skill([InfoA.showA_weapon, InfoA.skillA_weapon, InfoB.showB_weapon, InfoB.skillB_weapon,
    //                                             InfoAR1.showA_r1_weapon, InfoAR1.skillA_r1_weapon, InfoBR1.showB_r1_weapon, InfoBR1.skillB_r1_weapon,
    //                                             InfoAR2.showA_r2_weapon, InfoAR2.skillA_r2_weapon, InfoBR2.showB_r2_weapon, InfoBR2.skillB_r2_weapon], owner);   
    //     BornDNA.show_weapon = showC_skill_weapon[0];
    //     BornDNA.skill_weapon = showC_skill_weapon[1];
        
    //     BornDNA.show_platform = get_showC_platform_or_flag([InfoA.showA_platform, InfoB.showB_platform,
    //                                                     InfoAR1.showA_r1_platform, InfoBR1.showB_r1_platform,
    //                                                     InfoAR2.showA_r2_platform, InfoBR2.showB_r2_platform], owner);
          
        
    //     BornDNA.show_flag = get_showC_platform_or_flag([InfoA.showA_flag, InfoB.showB_flag,
    //                                                InfoAR1.showA_r1_flag, InfoBR1.showB_r1_flag,
    //                                                InfoAR2.showA_r2_flag, InfoBR2.showB_r2_flag], owner);

    //     BornDNA.showC = BornDNA.show_head.concat(BornDNA.show_hand);
    //     BornDNA.showC = BornDNA.showC.concat(BornDNA.show_body).concat(BornDNA.show_weapon);
    //     BornDNA.showC = BornDNA.showC.concat(BornDNA.show_platform).concat(BornDNA.show_flag);

    //     BornDNA.skillC = BornDNA.skill_head.concat(BornDNA.skill_hand);
    //     BornDNA.skillC = BornDNA.skillC.concat(BornDNA.skill_body).concat(BornDNA.skill_weapon);

    //     ShowCRes.showC_head_res = get_C_r1_r2([InfoA.showA_head, InfoB.showB_head, InfoAR1.showA_r1_head, 
    //                                 InfoBR1.showB_r1_head, InfoAR2.showA_r2_head, InfoBR2.showB_r2_head],
    //                                 [InfoA.skillA_head, InfoB.skillB_head, InfoAR1.skillA_r1_head,
    //                                 InfoBR1.skillB_r1_head, InfoAR2.skillA_r2_head, InfoBR2.skillB_r2_head], 
    //                                 BornDNA.show_head);
    //     ShowCRes.showC_hand_res = get_C_r1_r2([InfoA.showA_hand, InfoB.showB_hand, InfoAR1.showA_r1_hand,
    //                                 InfoBR1.showB_r1_hand, InfoAR2.showA_r2_hand, InfoBR2.showB_r2_hand],
    //                                 [InfoA.skillA_hand, InfoB.skillB_hand, InfoAR1.skillA_r1_hand, 
    //                                 InfoBR1.skillB_r1_hand, InfoAR2.skillA_r2_hand, InfoBR2.skillB_r2_hand],
    //                                 BornDNA.show_hand);
    //     ShowCRes.showC_body_res = get_C_r1_r2([InfoA.showA_body, InfoB.showB_body, InfoAR1.showA_r1_body, 
    //                                 InfoBR1.showB_r1_body, InfoAR2.showA_r2_body, InfoBR2.showB_r2_body],
    //                                 [InfoA.skillA_body, InfoB.skillB_body, InfoAR1.skillA_r1_body, 
    //                                 InfoBR1.skillB_r1_body, InfoAR2.skillA_r2_body, InfoBR2.skillB_r2_body],
    //                                 BornDNA.show_body);
    //     ShowCRes.showC_weapon_res = get_C_r1_r2([InfoA.showA_weapon, InfoB.showB_weapon, InfoAR1.showA_r1_weapon, 
    //                                 InfoBR1.showB_r1_weapon, InfoAR2.showA_r2_weapon, InfoBR2.showB_r2_weapon],
    //                                 [InfoA.skillA_weapon, InfoB.skillB_weapon, InfoAR1.skillA_r1_weapon, 
    //                                 InfoBR1.skillB_r1_weapon, InfoAR2.skillA_r2_weapon, InfoBR2.skillB_r2_weapon],
    //                                 BornDNA.show_weapon);
    //     ShowCRes.showC_platform_res = get_showC_r1_r2_platform_or_flag([InfoA.showA_platform, InfoB.showB_platform, InfoAR1.showA_r1_platform, 
    //                                 InfoBR1.showB_r1_platform, InfoAR2.showA_r2_platform, InfoBR2.showB_r2_platform], BornDNA.show_platform);
    //     ShowCRes.showC_flag_res = get_showC_r1_r2_platform_or_flag([InfoA.showA_flag, InfoB.showB_flag, InfoAR1.showA_r1_flag,
    //                                 InfoBR1.showB_r1_flag, InfoAR2.showA_r2_flag, InfoBR2.showB_r2_flag], BornDNA.show_flag);
    //     BornDNA.showC_r1 = ShowCRes.showC_head_res[0].concat(ShowCRes.showC_hand_res[0]);
    //     BornDNA.showC_r1 = BornDNA.showC_r1.concat(ShowCRes.showC_body_res[0]);
    //     BornDNA.showC_r1 = BornDNA.showC_r1.concat(ShowCRes.showC_weapon_res[0]);
    //     BornDNA.showC_r1 = BornDNA.showC_r1.concat(ShowCRes.showC_platform_res[0]);
    //     BornDNA.showC_r1 = BornDNA.showC_r1.concat(ShowCRes.showC_flag_res[0]);

    //     BornDNA.skillC_r1 = ShowCRes.showC_head_res[1].concat(ShowCRes.showC_hand_res[1]);
    //     BornDNA.skillC_r1 = BornDNA.skillC_r1.concat(ShowCRes.showC_body_res[1]);
    //     BornDNA.skillC_r1 = BornDNA.skillC_r1.concat(ShowCRes.showC_weapon_res[1]);

    //     BornDNA.showC_r2 = ShowCRes.showC_head_res[2].concat(ShowCRes.showC_hand_res[2]);
    //     BornDNA.showC_r2 = BornDNA.showC_r2.concat(ShowCRes.showC_body_res[2]);
    //     BornDNA.showC_r2 = BornDNA.showC_r2.concat(ShowCRes.showC_weapon_res[2]);
    //     BornDNA.showC_r2 = BornDNA.showC_r2.concat(ShowCRes.showC_platform_res[1]);
    //     BornDNA.showC_r2 = BornDNA.showC_r2.concat(ShowCRes.showC_flag_res[1]);

    //     BornDNA.skillC_r2 = ShowCRes.showC_head_res[3].concat(ShowCRes.showC_hand_res[3]);
    //     BornDNA.skillC_r2 = BornDNA.skillC_r2.concat(ShowCRes.showC_body_res[3]);
    //     BornDNA.skillC_r2 = BornDNA.skillC_r2.concat(ShowCRes.showC_weapon_res[3]);

    //     return [BornDNA.showC, BornDNA.skillC, BornDNA.showC_r1, BornDNA.skillC_r1, BornDNA.showC_r2, BornDNA.skillC_r2];
    // }

    function getBornDNA(uint256 parent_a_dna, uint256 parent_b_dna, address owner) public override returns(uint256 _dna) {
        bool isSeedReady = isRNGSeedReady(owner);
        require(isSeedReady, "RNG seed is not ready");

        string memory parentA_dna = Integers.toString(parent_a_dna);
        string memory parentB_dna = Integers.toString(parent_b_dna);
        ParentADNA memory ParentA;
        ParentBDNA memory ParentB;
        BornDNAInfo memory DNA;

        ParentA.batchA = parentA_dna._substring(2, 0); // 2
        ParentA.unitA = parentA_dna._substring(3, 2);  //3
        ParentA.campA = parentA_dna._substring(2, 5);  //2
        ParentA.attrA = parentA_dna._substring(8, 7); //8
        ParentA.showA = parentA_dna._substring(12, 15); //12
        ParentA.skillA = parentA_dna._substring(8, 27); //8
        ParentA.showA_r1 = parentA_dna._substring(12, 35); //12
        ParentA.skillA_r1 = parentA_dna._substring(8, 47); //8
        ParentA.showA_r2 = parentA_dna._substring(12, 55); // 12
        ParentA.skillA_r2 = parentA_dna._substring(8, 67); // 8

        ParentB.batchB = parentB_dna._substring(2, 0); // 2
        ParentB.unitB = parentB_dna._substring(3, 2);  //3
        ParentB.campB = parentB_dna._substring(2, 5);  //2
        ParentB.attrB = parentB_dna._substring(8, 7); //8
        ParentB.showB = parentB_dna._substring(12, 15); //12
        ParentB.skillB = parentB_dna._substring(8, 27); //8
        ParentB.showB_r1 = parentB_dna._substring(12, 35); //12
        ParentB.skillB_r1 = parentB_dna._substring(8, 47); //8
        ParentB.showB_r2 = parentB_dna._substring(12, 55); // 12
        ParentB.skillB_r2 = parentB_dna._substring(8, 67); // 8

        DNA.batchC = "10";
        DNA.unitC = get_unit(ParentA.unitA, ParentB.unitB, owner, 70000);
        DNA.campC = get_unit(ParentA.campA, ParentB.campB, owner, 50000);
        DNA.attrC = get_attr(ParentA.attrA, ParentB.attrB);
        string[6] memory show_skill= HeroGeneShowSkill(_HeroGeneShowSkillContract).get_show_skill([ParentA.showA, ParentA.skillA, ParentB.showB, ParentB.skillB,
                        ParentA.showA_r1, ParentA.skillA_r1, ParentA.showA_r2, ParentA.skillA_r2,
                        ParentB.showB_r1, ParentB.skillB_r1, ParentB.showB_r2, ParentB.skillB_r2], owner);

        string memory dna = DNA.batchC.concat(DNA.unitC);
        dna = dna.concat(DNA.campC);
        dna = dna.concat(DNA.attrC);
        dna = dna.concat(show_skill[0]);
        dna = dna.concat(show_skill[1]);
        dna = dna.concat(show_skill[2]);
        dna = dna.concat(show_skill[3]);
        dna = dna.concat(show_skill[4]);
        dna = dna.concat(show_skill[5]);
        _dna = parseIntSelf(dna);
    }
}
