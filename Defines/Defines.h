#include <Foundation/Foundation.h>

/**
   System specific defines
 */

#define CACHE_MEMORY_SIZE   10 * 1024 * 1024                 // 10Mb
#define CACHE_DISK_SIZE     100 * 1024 * 1024               // 100Mb

//Define for enabling/disabling json printout

#define RESULTDEBUG 1

/**
 * Result specific defines
 */

extern NSString * const PPPhotosKey;
extern NSString * const PPPhotoKey;
extern NSString * const PPPhotoMaxPagesKey;
extern NSString * const PPPhotoCurrentKey;
extern NSString * const PPTitleKey;

/**
 * Search specific defines
 */

extern NSString * const PPLastSearchKey;