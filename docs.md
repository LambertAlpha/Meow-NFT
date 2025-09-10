# Foundry版本 Meow-NFT 项目初始化指南

## 1. 安装 Foundry

### macOS/Linux
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Windows
使用 WSL (Windows Subsystem for Linux) 或下载预编译的二进制文件

## 2. 初始化项目

```bash
# 创建项目目录
mkdir meow-nft-foundry
cd meow-nft-foundry

# 使用 foundry 初始化项目
forge init --no-git .
```

## 3. 项目结构

初始化后，你的项目结构应该是这样的：
```
meow-nft-foundry/
├── foundry.toml          # Foundry 配置文件
├── src/                  # 智能合约源码
│   └── Counter.sol       # 示例合约（可删除）
├── script/               # 部署脚本
│   └── Counter.s.sol     # 示例脚本（可删除）
├── test/                 # 测试文件
│   └── Counter.t.sol     # 示例测试（可删除）
└── lib/                  # 依赖库
```

## 4. 安装依赖

```bash
# 安装 OpenZeppelin 合约库
forge install OpenZeppelin/openzeppelin-contracts

# 如果需要其他依赖，比如用于测试的工具
forge install foundry-rs/forge-std
```

## 5. 配置 foundry.toml

编辑项目根目录的 `foundry.toml` 文件：

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc = "0.8.19"
optimizer = true
optimizer_runs = 200
via_ir = false

# 映射 OpenZeppelin 合约路径
remappings = [
    "@openzeppelin/=lib/openzeppelin-contracts/"
]

# Polygon 网络配置
[rpc_endpoints]
polygon = "https://polygon-rpc.com"
mumbai = "https://rpc-mumbai.maticvigil.com"

# Gas 报告
gas_reports = ["*"]
```

## 6. 创建 MeowNFT 智能合约

删除示例文件并创建你的 NFT 合约：

```bash
rm src/Counter.sol
```

在 `src/` 目录下创建 `MeowNFT.sol`：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title CUHKSZ Meow NFT
 * @dev ERC721 contract for the campus cat collection.
 * Includes a batch airdrop function for efficient distribution.
 */
contract MeowNFT is ERC721, Ownable, ReentrancyGuard {
    using Strings for uint256;

    // The base URI pointing to the metadata folder on IPFS
    string private _baseTokenURI;
    
    // Total number of NFTs in this collection
    uint256 public constant MAX_SUPPLY = 60;
    
    // Current token ID counter
    uint256 public currentTokenId;
    
    // Mapping to track if an address has received an airdrop
    mapping(address => bool) public hasReceived;

    event BatchAirdrop(address[] recipients, uint256[] tokenIds);
    event BaseURIUpdated(string newBaseURI);

    /**
     * @dev Constructor sets the token name, symbol, and initial metadata URI
     */
    constructor(
        string memory _initialBaseURI
    ) ERC721("CUHKSZ Meow NFT", "MEOW") {
        _baseTokenURI = _initialBaseURI;
    }

    /**
     * @dev Returns the base URI for all token metadata
     */
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Returns the token URI for a given token ID
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
            : "";
    }

    /**
     * @dev Updates the base URI (only owner)
     */
    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }

    /**
     * @dev Batch airdrop NFTs to multiple addresses
     * @param recipients Array of addresses to receive NFTs
     */
    function airdropNFTs(address[] calldata recipients) external onlyOwner nonReentrant {
        require(recipients.length > 0, "No recipients provided");
        require(currentTokenId + recipients.length <= MAX_SUPPLY, "Airdrop exceeds max supply");
        
        uint256[] memory tokenIds = new uint256[](recipients.length);
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(!hasReceived[recipients[i]], "Address already received NFT");
            
            currentTokenId++;
            tokenIds[i] = currentTokenId;
            hasReceived[recipients[i]] = true;
            
            _safeMint(recipients[i], currentTokenId);
        }
        
        emit BatchAirdrop(recipients, tokenIds);
    }

    /**
     * @dev Get total number of minted tokens
     */
    function totalSupply() external view returns (uint256) {
        return currentTokenId;
    }

    /**
     * @dev Check if max supply has been reached
     */
    function isMaxSupplyReached() external view returns (bool) {
        return currentTokenId >= MAX_SUPPLY;
    }
}
```

## 7. 创建部署脚本

删除示例脚本并创建部署脚本：

```bash
rm script/Counter.s.sol
```

在 `script/` 目录下创建 `DeployMeowNFT.s.sol`：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract DeployMeowNFT is Script {
    function run() public {
        // ********** IMPORTANT **********
        // PASTE THE METADATA FOLDER CID FROM PINATA HERE
        string memory metadataBaseURI = "ipfs://QmYourMetadataFolderCIDGoesHere/";
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("Deploying MeowNFT contract...");
        console.log("Deployer address:", vm.addr(deployerPrivateKey));
        
        MeowNFT meowNFT = new MeowNFT(metadataBaseURI);
        
        console.log("MeowNFT contract deployed to:", address(meowNFT));
        console.log("Base URI set to:", metadataBaseURI);
        
        vm.stopBroadcast();
    }
}
```

## 8. 创建 Airdrop 脚本

在 `script/` 目录下创建 `AirdropMeowNFT.s.sol`：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract AirdropMeowNFT is Script {
    function run() public {
        // 替换为你已部署的合约地址
        address contractAddress = 0x...; // 填入实际合约地址
        
        // 替换为实际的接收地址列表
        address[] memory recipients = new address[](3);
        recipients[0] = 0x...; // 地址1
        recipients[1] = 0x...; // 地址2  
        recipients[2] = 0x...; // 地址3
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        MeowNFT meowNFT = MeowNFT(contractAddress);
        
        console.log("Starting airdrop to", recipients.length, "addresses...");
        
        meowNFT.airdropNFTs(recipients);
        
        console.log("Airdrop completed successfully!");
        
        vm.stopBroadcast();
    }
}
```

## 9. 创建环境配置

创建 `.env` 文件（不要提交到 git）：

```bash
# 你的私钥 (不要分享给任何人!)
PRIVATE_KEY=your_private_key_here

# RPC URLs
POLYGON_RPC_URL=https://polygon-rpc.com
MUMBAI_RPC_URL=https://rpc-mumbai.maticvigil.com

# Etherscan API Key (用于合约验证)
ETHERSCAN_API_KEY=your_etherscan_api_key
```

## 10. 编译和测试

```bash
# 编译合约
forge build

# 创建基础测试 (可选)
forge test

# 查看 gas 使用情况
forge test --gas-report
```

## 11. 部署到 Polygon

```bash
# 部署到 Polygon 主网
forge script script/DeployMeowNFT.s.sol --rpc-url $POLYGON_RPC_URL --broadcast --verify

# 或者先部署到 Mumbai 测试网
forge script script/DeployMeowNFT.s.sol --rpc-url $MUMBAI_RPC_URL --broadcast --verify
```

## 12. 执行 Airdrop

```bash
# 编辑 AirdropMeowNFT.s.sol 中的合约地址和接收地址
# 然后执行 airdrop
forge script script/AirdropMeowNFT.s.sol --rpc-url $POLYGON_RPC_URL --broadcast
```

## Foundry 相比 Hardhat 的优势

1. **更快的编译速度**: Foundry 使用 Rust 编写，编译速度极快
2. **原生 Solidity 测试**: 可以用 Solidity 编写测试，无需学习 JavaScript
3. **内置模糊测试**: 支持属性测试和模糊测试
4. **简单的依赖管理**: 使用 git submodules 管理依赖
5. **强大的调试工具**: 内置调试和追踪功能

## 下一步

1. 按照原文档准备图片和元数据
2. 将文件上传到 IPFS/Pinata
3. 更新部署脚本中的 baseURI
4. 编译、测试并部署合约
5. 收集钱包地址并执行 airdrop

现在你就有了一个完整的 Foundry 版本的 Meow-NFT 项目结构！