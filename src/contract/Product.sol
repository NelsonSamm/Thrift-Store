// SPDX-License-Identifier: MIT

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
        0x686c626E48bfC5DC98a30a9992897766fed4Abd3;

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
    function buyProduct(uint256 _index) public payable {
        Thrift storage currentThrift = thrifts[_index];
        require(currentThrift.sale, "Product is not on sale");
        require(currentThrift.creator != msg.sender, "You can't buy your product");
        currentThrift.sale = false;
        address creator = currentThrift.creator;
        currentThrift.creator = payable(msg.sender);
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                creator,
                currentThrift.price
            ),
            "Transfer failed."
        );
    }

    /**
        * @dev allow users to add a product on the platform
        * @notice input strings needs to be valid values
     */
    function addProduct(
        string calldata _url,
        string calldata _location,
        string calldata _serviceOption,
        uint256 _phone,
        uint256 _price
    ) public {
        require(bytes(_url).length > 0, "Empty url");
        require(bytes(_location).length > 0, "Empty location");
        require(bytes(_serviceOption).length > 0, "Empty service option");
        Thrift storage thrift = thrifts[thriftsLength];
        thriftsLength++;

        thrift.creator = payable(msg.sender);
        thrift.url = _url;
        thrift.location = _location;
        thrift.serviceOption = _serviceOption;
        thrift.phone = _phone;
        thrift.price = _price;
    }

    /**
        * @dev allows products' owners to toggle the sale status of their product
     */
    function toggleSale(uint256 _index) public {
        Thrift storage currentThrift = thrifts[_index];
        require(
            msg.sender == currentThrift.creator,
            "only the creator can access this function"
        );
        currentThrift.sale = !currentThrift.sale;
    }

    function getThriftsLength() public view returns (uint256) {
        return thriftsLength;
    }
}
