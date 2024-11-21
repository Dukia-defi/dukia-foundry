// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../lib/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "../lib/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "../lib/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "./interface/IERC20.sol";

contract UniswapIntegration {
    IUniswapV2Router02 public immutable uniswapRouter;
    address public owner;

    event TokensSwapped(
        address indexed sender,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] path,
        address indexed to,
        uint256 deadline,
        uint256[] amounts
    );
    // IUniswapV2Factory public uniswapFactory;

    constructor(address _uniswapRouter) {
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
        owner = msg.sender;
        // uniswapFactory = IUniswapV2Factory(UNISWAP_FACTORY_ADDRESS);
    }

    // Swap exact tokens for another token
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), "Transfer of token failed");
        IERC20(path[0]).approve(address(uniswapRouter), amountIn);

        amounts = uniswapRouter.swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);

        emit TokensSwapped(msg.sender, amountIn, amountOutMin, path, to, deadline, amounts);

        return amounts;
    }

    // // Add liquidity to a pair
    // function addLiquidity(
    //     address tokenA,
    //     address tokenB,
    //     uint amountA,
    //     uint amountB,
    //     uint amountAMin,
    //     uint amountBMin,
    //     uint deadline
    // ) external {
    //     IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
    //     IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

    //     IERC20(tokenA).approve(address(uniswapRouter), amountA);
    //     IERC20(tokenB).approve(address(uniswapRouter), amountB);

    //     uniswapRouter.addLiquidity(
    //         tokenA,
    //         tokenB,
    //         amountA,
    //         amountB,
    //         amountAMin,
    //         amountBMin,
    //         msg.sender,
    //         deadline
    //     );
    // }

    // // Remove liquidity from a pair
    // function removeLiquidity(
    //     address tokenA,
    //     address tokenB,
    //     uint liquidity,
    //     uint amountAMin,
    //     uint amountBMin,
    //     uint deadline
    // ) external {
    //     address pair = uniswapFactory.getPair(tokenA, tokenB);
    //     IERC20(pair).transferFrom(msg.sender, address(this), liquidity);
    //     IERC20(pair).approve(address(uniswapRouter), liquidity);

    //     uniswapRouter.removeLiquidity(
    //         tokenA,
    //         tokenB,
    //         liquidity,
    //         amountAMin,
    //         amountBMin,
    //         msg.sender,
    //         deadline
    //     );
    // }
}
