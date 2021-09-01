# CHI API Documents

## List strategies

```

function chi(uint256 tokenId)
    external
    view
    returns (
        address owner,
        address operator,
        address pool,
        address vault,
        uint256 accruedProtocolFees0,
        uint256 accruedProtocolFees1,
        uint24 fee, 
        uint256 totalShares
    );
```

## Create and Update strategy.

```
// Only strategy provider can mint chi strategy

function mint(MintParams calldata params, bytes32[] calldata merkleProof)
    external
    override
    onlyProviders(merkleProof)
    returns (uint256 tokenId, address vault)
{
    address uniswapPool = IUniswapV3Factory(v3Factory).getPool(
        params.token0,
        params.token1,
        params.fee
    );

    require(uniswapPool != address(0), "non-existent pool");

    vault = ICHIVaultDeployer(deployer).createVault(
        uniswapPool,
        address(this),
        _vaultFee
    );
    _mint(params.recipient, (tokenId = _nextId++));

    CHIConfig memory _config_ = CHIConfig({
        paused: false,
        archived: false,
        equational: true,
        maxUSDLimit: 0
    });

    _chi[tokenId] = CHIData({
        operator: params.recipient,
        pool: uniswapPool,
        vault: vault,
        config: _config_
    });

    emit Create(tokenId, uniswapPool, vault, _vaultFee);
}
```

### Add and remove range with or without percentages

```
function addRange(
    uint256 tokenId,
    int24 tickLower,
    int24 tickUpper
)
    external
    override
    isAuthorizedForToken(tokenId)
    onlyWhenNotPaused(tokenId)
{
    CHIData storage _chi_ = _chi[tokenId];
    ICHIVault vault = ICHIVault(_chi_.vault);
    LiquidityHelper.removeVaultAllLiquidityFromPosition(vault);
    vault.addRange(tickLower, tickUpper);
    _chi_.config.equational = true;

    emit ChangeLiquidity(tokenId, _chi_.vault);
}
```

```
function removeRange(
    uint256 tokenId,
    int24 tickLower,
    int24 tickUpper
)
    external
    override
    isAuthorizedForToken(tokenId)
    onlyWhenNotPaused(tokenId)
{
    CHIData storage _chi_ = _chi[tokenId];
    ICHIVault vault = ICHIVault(_chi_.vault);
    LiquidityHelper.removeVaultAllLiquidityFromPosition(vault);
    vault.removeRange(tickLower, tickUpper);
    _chi_.config.equational = true;

    emit ChangeLiquidity(tokenId, _chi_.vault);
}
```

```
function addAndRemoveRanges(
    uint256 tokenId,
    RangeParams[] calldata addRanges,
    RangeParams[] calldata removeRanges
)
    external
    override
    isAuthorizedForToken(tokenId)
    onlyWhenNotPaused(tokenId)
{
    CHIData storage _chi_ = _chi[tokenId];
    LiquidityHelper.addAndRemoveRanges(
        ICHIVault(_chi_.vault),
        addRanges,
        removeRanges
    );
    _chi_.config.equational = true;
    emit ChangeLiquidity(tokenId, _chi_.vault);
}
```

```
function addAndRemoveRangesWithPercents(
    uint256 tokenId,
    RangeParams[] calldata addRanges,
    RangeParams[] calldata removeRanges,
    uint256[] calldata percents
)
    external
    override
    isAuthorizedForToken(tokenId)
    onlyWhenNotPaused(tokenId)
{
    CHIData storage _chi_ = _chi[tokenId];
    LiquidityHelper.addAndRemoveRanges(
        ICHIVault(_chi_.vault),
        addRanges,
        removeRanges
    );
    _addTickPercents(_chi_.vault, percents);
    _chi_.config.equational = false;

    emit ChangeLiquidity(tokenId, _chi_.vault);
}
```

### Add range percentage

```
function addTickPercents(uint256 tokenId, uint256[] calldata percents)
    external
    override
    isAuthorizedForToken(tokenId)
{
    CHIData storage _chi_ = _chi[tokenId];
    LiquidityHelper.removeVaultAllLiquidityFromPosition(
        ICHIVault(_chi_.vault)
    );
    _addTickPercents(_chi_.vault, percents);
    _chi_.config.equational = false;

    emit ChangeLiquidity(tokenId, _chi_.vault);
}

```

### Swap balances inside vault

```
function swap(
    uint256 tokenId,
    address tokenIn,
    address tokenOut,
    uint256 percentage
) external override returns (uint256) {
    require(
        _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == executor,
        "not approved"
    );

    CHIData storage _chi_ = _chi[tokenId];
    uint256 amountOut = ICHIVault(_chi_.vault).swapPercentage(
        tokenIn,
        tokenOut,
        percentage
    );
    emit Swap(tokenId, tokenIn, tokenOut, percentage, amountOut);

    return amountOut;
}
```

### Collect Protocol fees

```
function collectProtocol(uint256 tokenId) external override {
    require(msg.sender == executor, "only executor");

    CHIData storage _chi_ = _chi[tokenId];
    ICHIVault vault = ICHIVault(_chi_.vault);
    uint256 accruedProtocolFees0 = vault.accruedProtocolFees0();
    uint256 accruedProtocolFees1 = vault.accruedProtocolFees1();

    uint256 amount0 = accruedProtocolFees0.mul(_providerFee).div(1e6);
    uint256 amount1 = accruedProtocolFees1.div(_providerFee).div(1e6);

    vault.collectProtocol(
        amount0,
        amount1,
        IERC721(address(this)).ownerOf(tokenId)
    );
    vault.collectProtocol(
        accruedProtocolFees0.sub(amount0),
        accruedProtocolFees1.sub(amount1),
        treasury
    );
}
```

### addAllLiquidityToPositionEvent

trigger all liquidity to position event

```
function addAllLiquidityToPositionEvent(
    uint256 tokenId,
    uint256 amount0Total,
    uint256 amount1Total
) external override isAuthorizedForToken(tokenId) onlyWhenNotPaused(tokenId)
{
    emit AddAllLiquidity(msg.sender, tokenId, amount0Total, amount1Total);
}

```
