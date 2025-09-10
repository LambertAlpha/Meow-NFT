// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract AirdropMeowNFT is Script {
    function run() public {
        // 替换为你已部署的合约地址
        address contractAddress = 0x1234567890123456789012345678901234567890; // 填入实际合约地址
        
        // 替换为实际的接收地址列表
        address[] memory recipients = new address[](3);
        recipients[0] = 0x1111111111111111111111111111111111111111; // 地址1
        recipients[1] = 0x2222222222222222222222222222222222222222; // 地址2  
        recipients[2] = 0x3333333333333333333333333333333333333333; // 地址3
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        MeowNFT meowNFT = MeowNFT(contractAddress);
        
        console.log("Starting airdrop to", recipients.length, "addresses...");
        
        meowNFT.airdropNFTs(recipients);
        
        console.log("Airdrop completed successfully!");
        
        vm.stopBroadcast();
    }
}