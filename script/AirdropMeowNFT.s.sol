// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract AirdropMeowNFTTest is Script {
    function run() public {
        // 替换为你已部署的合约地址
        address contractAddress = 0x1234567890123456789012345678901234567890; // 填入实际合约地址
        
        // 测试空投：只给自己（部署者）
        address[] memory recipients = new address[](1);
        recipients[0] = 0x您的钱包地址; // 替换为您的实际钱包地址
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        MeowNFT meowNFT = MeowNFT(contractAddress);
        
        console.log("Starting TEST airdrop to deployer address...");
        console.log("Recipient:", recipients[0]);
        console.log("This will mint Token ID 1");
        
        meowNFT.airdropNFTs(recipients);
        
        console.log("Test airdrop completed! Check your wallet for NFT #1");
        
        vm.stopBroadcast();
    }
}