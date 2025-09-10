// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract AirdropMeowNFTBatch2 is Script {
    function run() public {
        // 替换为你已部署的合约地址
        address contractAddress = 0x1234567890123456789012345678901234567890; // 填入实际合约地址
        
        // 第二批：地址2-50（共49个地址）
        address[] memory recipients = new address[](49);
        
        // 请替换为实际的接收地址列表
        recipients[0] = 0x地址2;   // 将获得 Token ID 2
        recipients[1] = 0x地址3;   // 将获得 Token ID 3
        recipients[2] = 0x地址4;   // 将获得 Token ID 4
        // ... 继续添加地址
        recipients[48] = 0x地址50; // 将获得 Token ID 50
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        MeowNFT meowNFT = MeowNFT(contractAddress);
        
        console.log("Starting BATCH 2 airdrop to", recipients.length, "addresses...");
        console.log("This will mint Token IDs 2-50");
        
        meowNFT.airdropNFTs(recipients);
        
        console.log("Batch 2 airdrop completed successfully!");
        
        vm.stopBroadcast();
    }
}
