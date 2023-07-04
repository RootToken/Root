// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
pragma experimental ABIEncoderV2;

import "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";

enum ConvertKind {
    BEANS_TO_CURVE_LP,
    CURVE_LP_TO_BEANS,
    UNRIPE_BEANS_TO_UNRIPE_LP,
    UNRIPE_LP_TO_UNRIPE_BEANS,
    LAMBDA_LAMBDA
}

enum From {
    EXTERNAL,
    INTERNAL,
    EXTERNAL_INTERNAL,
    INTERNAL_TOLERANT
}
enum To {
    EXTERNAL,
    INTERNAL
}

struct SiloSettings {
    bytes4 selector;
    uint32 stalkEarnedPerSeason;
    uint32 stalkIssuedPerBdv;
    uint32 milestoneSeason;
    int96 milestoneStem;
}

interface IBeanstalk {
    function balanceOfStalk(address account) external view returns (uint256);

    function transferDeposits(
        address sender,
        address recipient,
        address token,
        int96[] calldata stems,
        uint256[] calldata amounts
    ) external payable returns (uint256[] memory bdvs);

    function permitDeposit(
        address owner,
        address spender,
        address token,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable;

    function permitDeposits(
        address owner,
        address spender,
        address[] calldata tokens,
        uint256[] calldata values,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable;

    function plant() external payable returns (uint256);

    function mow(address account, address token) external payable;

    function transferInternalTokenFrom(
        IERC20Upgradeable token,
        address from,
        address to,
        uint256 amount,
        To toMode
    ) external payable;

    function transferToken(
        IERC20Upgradeable token,
        address recipient,
        uint256 amount,
        From fromMode,
        To toMode
    ) external payable;

    function permitToken(
        address owner,
        address spender,
        address token,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable;

    function convert(
        bytes calldata convertData,
        int96[] memory stems,
        uint256[] memory amounts
    )
        external
        payable
        returns (
            int96 toStem,
            uint256 fromAmount,
            uint256 toAmount,
            uint256 fromBdv,
            uint256 toBdv
        );

    function getDeposit(
        address account,
        address token,
        int96 stem
    ) external view returns (uint256, uint256);

    function getSeedsPerToken(address token) external view returns (uint256);
}
