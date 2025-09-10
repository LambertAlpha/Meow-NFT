// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract AirdropMeowNFTBatch3 is Script {
    function run() public {
        // 替换为你已部署的合约地址
        address contractAddress = 0x1234567890123456789012345678901234567890; // 填入实际合约地址
        
        // 第三批：地址51-68（共18个地址）
        address[] memory recipients = new address[](18);
        
        // 请替换为实际的接收地址列表
        recipients[0] = 0x地址51;  // 将获得 Token ID 51
        recipients[1] = 0x地址52;  // 将获得 Token ID 52
        recipients[2] = 0x地址53;  // 将获得 Token ID 53
        // ... 继续添加地址
        recipients[17] = 0x地址68; // 将获得 Token ID 68
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        MeowNFT meowNFT = MeowNFT(contractAddress);
        
        console.log("Starting BATCH 3 airdrop to", recipients.length, "addresses...");
        console.log("This will mint Token IDs 51-68");
        
        meowNFT.airdropNFTs(recipients);
        
        console.log("Batch 3 airdrop completed successfully!");
        
        vm.stopBroadcast();
    }
}
