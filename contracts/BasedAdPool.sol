// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {ISuperfluidPool, PoolConfig} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/gdav1/IGeneralDistributionAgreementV1.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

contract BasedAdPool is Ownable {
    using SuperTokenV1Library for ISuperToken;

    ISuperToken private superToken;
    ISuperfluidPool private pool;
    PoolConfig private poolConfig;
    struct Participant {
        address participantAddress;
        uint256 flowRate;
    }
    mapping(address => Participant) private participants;

    constructor(ISuperToken _superToken) {
        superToken = _superToken;
        poolConfig = PoolConfig({
            transferabilityForUnitsOwner: true,
            distributionFromAnyAddress: true
        });
        pool = superToken.createPool(address(this), poolConfig);
    }

    function updateMemberUnits(address member, uint128 units) onlyOwner public {
        superToken.updateMemberUnits(pool, member, units);
    }

    function becomeParticipant(address participant, uint128 factor) onlyOwner public {
        superToken.connectPool(superToken,pool);
        updateMemberUnits(participant, factor);
        participants[participant] = Participant(participant, factor);
    }

    function updateFlowForAllParticipants(address[] memory addresses, uint256[] memory flowRates) onlyOwner public {
        for (uint i = 0; i < addresses.length; i++) {
            if (participants[addresses[i]].participantAddress != address(0)) {
                participants[addresses[i]].flowRate = flowRates[i];
            }
            superToken.updateMemberUnits(pool, addresses[i], flowRates[i]);
        }
    }

    function removeParticipant(address participant) onlyOwner public {
        superToken.updateMemberUnits(pool, participant, 0);
    }

    function addFunds(uint256 adBudget) public {
        superToken.distributeToPool(superToken, msg.sender, pool, adBudget);
    }

    function getPool() public view returns (ISuperfluidPool) {
        return pool;
    }

    function getSuperToken() public view returns (ISuperToken) {
        return superToken;
    }

    function getAllParticipants() public view returns (address[] memory, uint256[] memory) {
        address[] memory participantAddresses = new address[](address(this).balance);
        uint256[] memory flowRates = new uint256[](address(this).balance);

        uint256 index = 0;
        for (uint256 i = 0; i < address(this).balance; i++) {
            if (participants[address(i)].participantAddress != address(0)) {
                participantAddresses[index] = participants[address(i)].participantAddress;
                flowRates[index] = participants[address(i)].flowRate;
                index++;
            }
        }

    return (participantAddresses, flowRates);
}
}