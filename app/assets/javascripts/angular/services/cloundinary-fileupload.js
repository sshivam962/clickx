clickxApp.service('CloudinaryService', [
  '$upload',
  '$q',
  function($upload, $q) {
    /**
     *
     * @param fileObject
     * @returns {*}
     */
    this.uploadFile = function(fileObject) {
      var defer = $q.defer();
      var tags = '';
      if (Array.isArray(fileObject.tags)) {
        tags = fileObject.tags.join(',');
      }
      return $upload.upload({
        url:
          'https://api.cloudinary.com/v1_1/' +
          $.cloudinary.config().cloud_name +
          '/upload',
        fields: {
          upload_preset: $.cloudinary.config().upload_preset,
          folder: fileObject.folderName || 'common',
          tags: tags || 'common'
        },
        file: fileObject.file
      });
    };
    /**
     *
     * @param fileObject
     */
    this.deleteFile = function(fileObject) {};
    /**
     *
     * @param imageId
     */
    this.getImageDetails = function(imageId) {};
    /**
     *
     * @param fileObject
     */
    this.sendEncodeImageData = function(fileObject) {};
  }
]);
