//
// Created by denghaidong on 16/11/14.
//

#ifdef __ANDROID__

#include <jni.h>
#include <android/log.h>
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO , "SDL", __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR , "SDL", __VA_ARGS__)
#else
#define LOGE(format, ...)  printf("(>_<) " format "\n", ##__VA_ARGS__)
#define LOGI(format, ...)  printf("(^_^) " format "\n", ##__VA_ARGS__)
#endif

#include "SDL.h"
#include "SDL_log.h"
#include "SDL_main.h"
#include <SDL_image.h>

int main(int argc, char *argv[]) {
    struct SDL_Window *window = NULL;
    struct SDL_Renderer *render = NULL;
    struct SDL_Surface *bmp = NULL;
    struct SDL_Texture *texture = NULL;

    int mWidth;
    		int mHeight;

    		void* mPixels;
            		int mPitch;

    char *filepath = "portrait.png";

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER) == -1) {
        LOGE("SDL_Init failed %s", SDL_GetError());
    }

    window = SDL_CreateWindow("SDL HelloWorld!", 100, 100, 640, 480,
            SDL_WINDOW_SHOWN);
    if (window == NULL) {
        LOGE("SDL_CreateWindow failed  %s", SDL_GetError());
    }

    render = SDL_CreateRenderer(window, -1,
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (render == NULL) {
       LOGE("SDL_CreateRenderer failed  %s", SDL_GetError());
    }
    bmp = IMG_Load(filepath);
    LOGE("go image_load fail", SDL_GetError());
    if (bmp == NULL) {
            LOGE("SDL_LoadBMP failed: %s", SDL_GetError());
        }
    SDL_Surface* formattedSurface = SDL_ConvertSurfaceFormat(bmp, SDL_PIXELFORMAT_RGBA8888, NULL );
    if( formattedSurface == NULL )
     		{
     			SDL_Log( "Unable to convert loaded surface to display format! %s\n", SDL_GetError() );
     		}
     		else
     		{
     		texture =SDL_CreateTexture(render, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, formattedSurface->w, formattedSurface->h );
     		LOGE("succuss create texture wait to display", SDL_GetError());
     		if( texture == NULL )
            			{
            				SDL_Log( "Unable to create blank texture! SDL Error: %s\n", SDL_GetError() );
            			}
            			else
            			{
            				//Enable blending on texture
            				//Enable blending on texture
                            				SDL_SetTextureBlendMode( texture, SDL_BLENDMODE_BLEND );

                            				//Lock texture for manipulation
                            				SDL_LockTexture( texture, &formattedSurface->clip_rect, &mPixels, &mPitch );

                            				//Copy loaded/formatted surface pixels
                            				memcpy( mPixels, formattedSurface->pixels, formattedSurface->pitch * formattedSurface->h );

                            				//Get image dimensions
                            				mWidth = formattedSurface->w;
                            				mHeight = formattedSurface->h;

                            				//Get pixel data in editable format
                            				Uint32* pixels = (Uint32*)mPixels;
                            				int pixelCount = ( mPitch / 4 ) * mHeight;

                            				//Map colors
                            				Uint32 colorKey = SDL_MapRGB( formattedSurface->format, 0, 0xFF, 0xFF );
                            				Uint32 transparent = SDL_MapRGBA( formattedSurface->format, 0x00, 0xFF, 0xFF, 0x00 );

                            				//Color key pixels
                            				for( int i = 0; i < pixelCount; ++i )
                            				{
                            					if( pixels[ i ] == colorKey )
                            					{
                            						pixels[ i ] = transparent;
                            					}
                            				}

                            				//Unlock texture to update
                            				SDL_UnlockTexture( texture );
                            				mPixels = NULL;}
     		}


   // texture = SDL_CreateTextureFromSurface(render, bmp);
    SDL_FreeSurface(bmp);
    SDL_FreeSurface(formattedSurface);

    SDL_RenderClear(render);
    SDL_RenderCopy(render, texture, NULL, NULL);
    SDL_RenderPresent(render);

    SDL_Delay(10000);

    //SDL_DestroyTexture(texture);
    //SDL_DestroyRenderer(render);
    //SDL_DestroyWindow(window);

    //Quit SDL
    //SDL_Quit();
    return 0;
}