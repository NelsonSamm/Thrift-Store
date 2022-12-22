pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Thriftly {
    uint256 private thriftsLength = 0;
    address internal cUsdTokenAddress =
        0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
         event unlistProductEvent(uint256 productId);
          event buyProductEvent(
        address indexed seller,
        address indexed buyer,
        uint256 index
    );


    struct Thrift {
        address payable creator;
        string url;
        string location;
        string serviceOption;
        uint256 phone;
        uint256 price;
        bool sale;
    }
    mapping(uint256 => Thrift) internal thrifts;

    function getProduct(uint256 _index)
        public
        view
        returns (
            address payable creator,
            string memory url,
            string memory location,
            string memory serviceOption,
            uint256 phone,
            uint256 price,
            bool sale
        )
    {
        Thrift storage currentThrift = thrifts[_index];
        creator = currentThrift.creator;
        url = currentThrift.url;
        location = currentThrift.location;
        serviceOption = currentThrift.serviceOption;
        phone = currentThrift.phone;
        price = currentThrift.price;
        sale = currentThrift.sale;
    }

    /**
        * @dev allow users to buy products found in a thrift store
     */
      function buyProduct(uint _index) public payable  {
        Thrift storage currentThrift = thrifts[_index];
        require(!currentThrift.sale, "Product already sold");
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                currentThrift.creator,
                currentThrift.price
            ),
            "Transfer failed."
        );

        address seller = currentThrift.creator;
        address buyer = msg.sender;

        currentThrift.creator = payable(msg.sender);
        currentThrift.sale = true;

        emit buyProductEvent(seller, buyer, _index);
    }

      function unlistProduct(uint _index) external {
        Thrift storage currentThrift = thrifts[_index];
        require(msg.sender == currentThrift.creator, "Only owner can unlist");
        require(!currentThrift.sale, "Product already sold");
