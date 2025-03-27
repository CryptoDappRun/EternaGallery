// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImageStorage {
    struct Image {
        string title;
        string imageData;
        address uploader;
        uint256 createdAt; 
    }
    
    Image[] public images;
    
    event ImageUploaded(string title, address uploader, uint256 createdAt);
    
    function uploadImage(string memory _title, string memory _imageData) public {
        uint256 timestamp = block.timestamp; 
        images.push(Image(_title, _imageData, msg.sender, timestamp));
        emit ImageUploaded(_title, msg.sender, timestamp);
    }
    
    function getImageCount() public view returns (uint256) {
        return images.length;
    }
    
    function getImage(uint256 _index) public view returns (string memory, string memory, address, uint256) {
        require(_index < images.length, "Image index out of bounds");
        Image memory img = images[_index];
        return (img.title, img.imageData, img.uploader, img.createdAt);
    }

    function searchImages(string memory _query) public view returns (uint256[] memory) {
        uint256[] memory tempResults = new uint256[](images.length);
        uint256 resultCount = 0;

        for (uint256 i = 0; i < images.length; i++) {
            if (contains(images[i].title, _query)) {
                tempResults[resultCount] = i;
                resultCount++;
            }
        }

        uint256[] memory results = new uint256[](resultCount);
        for (uint256 i = 0; i < resultCount; i++) {
            results[i] = tempResults[i];
        }

        return results;
    }


    function searchImagesByTime(uint256 _startTime, uint256 _endTime) public view returns (uint256[] memory) {
        uint256[] memory tempResults = new uint256[](images.length);
        uint256 resultCount = 0;

        for (uint256 i = 0; i < images.length; i++) {
            if (images[i].createdAt >= _startTime && images[i].createdAt <= _endTime) {
                tempResults[resultCount] = i;
                resultCount++;
            }
        }

        uint256[] memory results = new uint256[](resultCount);
        for (uint256 i = 0; i < resultCount; i++) {
            results[i] = tempResults[i];
        }

        return results;
    }

    function contains(string memory _str, string memory _sub) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        bytes memory subBytes = bytes(_sub);
        
        if (subBytes.length == 0 || strBytes.length < subBytes.length) {
            return false;
        }

        for (uint256 i = 0; i <= strBytes.length - subBytes.length; i++) {
            bool found = true;
            for (uint256 j = 0; j < subBytes.length; j++) {
                if (strBytes[i + j] != subBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return true;
            }
        }
        return false;
    }
}