namespace SDL3.Raw;

using System;
using System.Interop;

static
{

	//SDL_assert.h

	public enum SDL_AssertState : c_int
	{
		SDL_ASSERTION_RETRY, /**< Retry the assert immediately. */
		SDL_ASSERTION_BREAK, /**< Make the debugger trigger a breakpoint. */
		SDL_ASSERTION_ABORT, /**< Terminate the program. */
		SDL_ASSERTION_IGNORE, /**< Ignore the assert. */
		SDL_ASSERTION_ALWAYS_IGNORE /**< Ignore the assert from now on. */
	}

	[CRepr]
	public struct SDL_AssertData
	{
		public c_bool always_ignore; /**< true if app should always continue when assertion is triggered. */
		public c_uint trigger_count; /**< Number of times this assertion has been triggered. */
		public c_char* condition; /**< A string of this assert's test code. */
		public c_char* filename; /**< The source file where this assert lives. */
		public c_int linenum; /**< The line in `filename` where this assert lives. */
		public c_char* function_; /**< The name of the function where this assert lives. */
		public SDL_AssertData* next; /**< next item in the linked list. */
	}

	public typealias SDL_AssertionHandler = function SDL_AssertState(SDL_AssertData* data, void* userdate);

	[CLink] public static extern SDL_AssertState SDL_ReportAssertion(SDL_AssertData* data, c_char* func, c_char* file, c_int line);

	[CLink] public static extern void SDL_SetAssertionHandler(SDL_AssertionHandler handler, void* userdata);

	[CLink] public static extern SDL_AssertionHandler SDL_GetDefaultAssertionHandler();

	[CLink] public static extern SDL_AssertionHandler SDL_GetAssertionHandler(void** puserdata);

	[CLink] public static extern SDL_AssertData* SDL_GetAssertionReport();

	[CLink] public static extern void SDL_ResetAssertionReport();

	//SDL_asyncio.h

	public struct SDL_AsyncIO;

	public enum SDL_AsyncIOTaskType : c_int
	{
		SDL_ASYNCIO_TASK_READ,
		SDL_ASYNCIO_TASK_WRITE,
		SDL_ASYNCIO_TASK_CLOSE
	}

	public enum SDL_AsyncIOResult : c_int
	{
		SDL_ASYNCIO_COMPLETE,
		SDL_ASYNCIO_FAILURE,
		SDL_ASYNCIO_CANCELED
	}

	[CRepr]
	public struct SDL_AsyncIOOutcome
	{
		public SDL_AsyncIO* asyncio;
		public SDL_AsyncIOTaskType type;
		public SDL_AsyncIOResult result;
		public void* buffer;
		public uint64 offset;
		public uint64 bytes_requested;
		public uint64 bytes_transferred;
		public void* userdata;
	}

	public struct SDL_AsyncIOQueue;

	[CLink] public static extern SDL_AsyncIO* SDL_AsyncIOFromFile(c_char* file, c_char* mode);

	[CLink] public static extern int64 SDL_GetAsyncIOSize(SDL_AsyncIO* asyncio);

	[CLink] public static extern c_bool SDL_ReadAsyncIO(SDL_AsyncIO* asyncio, void* ptr, uint64 offset, uint64 size, SDL_AsyncIOQueue* queue, void* userdata);

	[CLink] public static extern c_bool SDL_WriteAsyncIO(SDL_AsyncIO* asyncio, void* ptr, uint64 offset, uint64 size, SDL_AsyncIOQueue* queue, void* userdata);

	[CLink] public static extern c_bool SDL_CloseAsyncIO(SDL_AsyncIO* asyncio, c_bool flush, SDL_AsyncIOQueue* queue, void* userdata);

	[CLink] public static extern SDL_AsyncIOQueue* SDL_CreateAsyncIOQueue();

	[CLink] public static extern void SDL_DestroyAsyncIOQueue(SDL_AsyncIOQueue* queue);

	[CLink] public static extern c_bool SDL_GetAsyncIOResult(SDL_AsyncIOQueue* queue, SDL_AsyncIOOutcome* outcome);

	[CLink] public static extern c_bool SDL_WaitAsyncIOResult(SDL_AsyncIOQueue* queue, SDL_AsyncIOOutcome* outcome, c_int timeoutMS);

	[CLink] public static extern void SDL_SignalAsyncIOQueue(SDL_AsyncIOQueue* queue);

	[CLink] public static extern c_bool SDL_LoadFileAsync(c_char* file, SDL_AsyncIOQueue* queue, void* userdata);

	//SDL_atomic.h

	public typealias SDL_SpinLock = c_int;

	[CRepr]
	public struct SDL_AtomicInt
	{
		public c_int value;
	}

	[CRepr]
	public struct SDL_AtomicU32
	{
		public uint32 value;
	}

	[CLink] public static extern c_bool SDL_TryLockSpinlock(SDL_SpinLock* lock);

	[CLink] public static extern void SDL_LockSpinlock(SDL_SpinLock* lock);

	[CLink] public static extern void SDL_UnlockSpinlock(SDL_SpinLock* lock);

	[CLink] public static extern void SDL_MemoryBarrierReleaseFunction();

	public static void SDL_MemoryBarrierRelease() => SDL_MemoryBarrierReleaseFunction();

	[CLink] public static extern void SDL_MemoryBarrierAcquireFunction();

	public static void SDL_MemoryBarrierAcquire() => SDL_MemoryBarrierAcquireFunction();

	[CLink] public static extern c_bool SDL_CompareAndSwapAtomicInt(SDL_AtomicInt* a, c_int oldval, c_int newval);

	[CLink] public static extern c_int SDL_SetAtomicInt(SDL_AtomicInt* a, c_int v);

	[CLink] public static extern c_int SDL_GetAtomicInt(SDL_AtomicInt* a);

	[CLink] public static extern c_int SDL_AddAtomicInt(SDL_AtomicInt* a, c_int v);

	[CLink] public static extern c_bool SDL_CompareAndSwapAtomicU32(SDL_AtomicU32* a, uint32 oldval, uint32 newval);

	[CLink] public static extern uint32 SDL_SetAtomicU32(SDL_AtomicU32* a, uint32 v);

	[CLink] public static extern uint32 SDL_GetAtomicU32(SDL_AtomicU32* a);

	[CLink] public static extern c_bool SDL_CompareAndSwapAtomicPointer(void** a, void* oldval, void* newval);

	[CLink] public static extern void*  SDL_SetAtomicPointer(void** a, void* v);

	[CLink] public static extern void*  SDL_GetAtomicPointer(void** a);

	public static c_int SDL_AtomicIncRef(SDL_AtomicInt* a) => SDL_AddAtomicInt(a, 1);

	public static c_bool SDL_AtomicDecRef(SDL_AtomicInt* a) => (SDL_AddAtomicInt(a, -1) == 1);

	//SDL_audio.h
	public typealias SDL_AudioStreamCallback = function void(void* userdata, SDL_AudioStream* stream, c_int additional_amount, c_int total_amount);

	public const uint32 SDL_AUDIO_MASK_BITSIZE = (0xFFu);

	public const uint32 SDL_AUDIO_MASK_FLOAT = (1u << 8);

	public const uint32 SDL_AUDIO_MASK_BIG_ENDIAN = (1u << 12);

	public const uint32 SDL_AUDIO_MASK_SIGNED = (1u << 15);

	public static SDL_AudioFormat SDL_DEFINE_AUDIO_FORMAT(bool signed, c_bool bigendian, c_bool flt, uint32 size)
	{
		return (SDL_AudioFormat)(((uint16)(signed ? 1 : 0) << 15) | ((uint16)(bigendian ? 1 : 0) << 12) | ((uint16)(flt ? 1 : 0) << 8) | ((size) & SDL_AUDIO_MASK_BITSIZE));
	}

	public static uint32 SDL_AUDIO_BITSIZE(SDL_AudioFormat x)
	{
		return (uint32)((x) & (SDL_AudioFormat)SDL_AUDIO_MASK_BITSIZE);
	}

	public static uint32 SDL_AUDIO_BYTESIZE(SDL_AudioFormat x)
	{
		return ((uint32)SDL_AUDIO_BITSIZE(x) / 8);
	}

	public static c_bool SDL_AUDIO_ISFLOAT(SDL_AudioFormat x)
	{
		return ((x) & (SDL_AudioFormat)SDL_AUDIO_MASK_FLOAT) != 0;
	}

	public static c_bool SDL_AUDIO_ISBIGENDIAN(SDL_AudioFormat x)
	{
		return ((x) & (SDL_AudioFormat)SDL_AUDIO_MASK_BIG_ENDIAN) != 0;
	}

	public static c_bool SDL_AUDIO_ISLITTLEENDIAN(SDL_AudioFormat x)
	{
		return (!SDL_AUDIO_ISBIGENDIAN(x));
	}

	public static c_bool SDL_AUDIO_ISSIGNED(SDL_AudioFormat x)
	{
		return ((x) & (SDL_AudioFormat)SDL_AUDIO_MASK_SIGNED) != 0;
	}

	public static c_bool SDL_AUDIO_ISINT(SDL_AudioFormat x)
	{
		return (!SDL_AUDIO_ISFLOAT(x));
	}

	public static c_bool SDL_AUDIO_ISUNSIGNED(SDL_AudioFormat x)
	{
		return (!SDL_AUDIO_ISSIGNED(x));
	}

	public const uint32 SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK = ((SDL_AudioDeviceID)0xFFFFFFFF);

	public const uint32 SDL_AUDIO_DEVICE_DEFAULT_RECORDING = ((SDL_AudioDeviceID)0xFFFFFFFE);

	public typealias SDL_AudioDeviceID = uint32;

	[CRepr]
	public struct SDL_AudioSpec
	{
		public SDL_AudioFormat format; /**< Audio data format */
		public c_int channels; /**< Number of channels: 1 mono, 2 stereo, etc */
		public c_int freq; /**< sample rate: sample frames per second */
	}

	public static uint32 SDL_AUDIO_FRAMESIZE(SDL_AudioSpec x)
	{
		return (SDL_AUDIO_BYTESIZE((x).format) * (uint32)((x).channels));
	}

	[AllowDuplicates]
	public enum SDL_AudioFormat : c_int
	{
		SDL_AUDIO_UNKNOWN   = 0x0000u, /**< Unspecified audio format */
		SDL_AUDIO_U8        = 0x0008u, /**< Unsigned 8-bit samples */
			/* SDL_DEFINE_AUDIO_FORMAT(0, 0, 0, 8), */
		SDL_AUDIO_S8        = 0x8008u, /**< Signed 8-bit samples */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 8), */
		SDL_AUDIO_S16LE     = 0x8010u, /**< Signed 16-bit samples */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 16), */
		SDL_AUDIO_S16BE     = 0x9010u, /**< As above, but big-endian byte order */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 1, 0, 16), */
		SDL_AUDIO_S32LE     = 0x8020u, /**< 32-bit integer samples */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 32), */
		SDL_AUDIO_S32BE     = 0x9020u, /**< As above, but big-endian byte order */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 1, 0, 32), */
		SDL_AUDIO_F32LE     = 0x8120u, /**< 32-bit floating poc_intsamples */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 0, 1, 32), */
		SDL_AUDIO_F32BE     = 0x9120u, /**< As above, but big-endian byte order */
			/* SDL_DEFINE_AUDIO_FORMAT(1, 1, 1, 32), */

		/* These represent the current system's byteorder. */
		#if !BIGENDIAN //SDL_BYTEORDER == SDL_LIL_ENDIAN
		SDL_AUDIO_S16 = SDL_AUDIO_S16LE,
		SDL_AUDIO_S32 = SDL_AUDIO_S32LE,
		SDL_AUDIO_F32 = SDL_AUDIO_F32LE
		#else
		SDL_AUDIO_S16 = SDL_AUDIO_S16BE,
		SDL_AUDIO_S32 = SDL_AUDIO_S32BE,
		SDL_AUDIO_F32 = SDL_AUDIO_F32BE
		#endif
	}

	public struct SDL_AudioStream;

	public typealias SDL_AudioPostmixCallback = function void(void* userdate, SDL_AudioSpec* spec, float* buffer, c_int buflen);

	public struct SDL_IOStream;

	[CLink] public static extern c_bool SDL_IsAudioDevicePhysical(SDL_AudioDeviceID devid);

	[CLink] public static extern c_bool SDL_IsAudioDevicePlayback(SDL_AudioDeviceID devid);

	[CLink] public static extern c_int SDL_GetNumAudioDrivers();

	[CLink] public static extern c_char* SDL_GetAudioDriver(c_int index);

	[CLink] public static extern c_char* SDL_GetCurrentAudioDriver();

	[CLink] public static extern SDL_AudioDeviceID*  SDL_GetAudioPlaybackDevices(c_int* count);

	[CLink] public static extern SDL_AudioDeviceID* SDL_GetAudioRecordingDevices(c_int* count);

	[CLink] public static extern c_char* SDL_GetAudioDeviceName(SDL_AudioDeviceID devid);

	[CLink] public static extern c_bool SDL_GetAudioDeviceFormat(SDL_AudioDeviceID devid, SDL_AudioSpec* spec, c_int* sample_frames);

	[CLink] public static extern c_int*  SDL_GetAudioDeviceChannelMap(SDL_AudioDeviceID devid, c_int* count);

	[CLink] public static extern SDL_AudioDeviceID SDL_OpenAudioDevice(SDL_AudioDeviceID devid, SDL_AudioSpec* spec);

	[CLink] public static extern c_bool SDL_PauseAudioDevice(SDL_AudioDeviceID dev);

	[CLink] public static extern c_bool SDL_ResumeAudioDevice(SDL_AudioDeviceID dev);

	[CLink] public static extern c_bool SDL_AudioDevicePaused(SDL_AudioDeviceID dev);

	[CLink] public static extern float SDL_GetAudioDeviceGain(SDL_AudioDeviceID devid);

	[CLink] public static extern c_bool SDL_SetAudioDeviceGain(SDL_AudioDeviceID devid, float gain);

	[CLink] public static extern void SDL_CloseAudioDevice(SDL_AudioDeviceID devid);

	[CLink] public static extern c_bool SDL_BindAudioStreams(SDL_AudioDeviceID devid, SDL_AudioStream** streams, c_int num_streams);

	[CLink] public static extern c_bool SDL_BindAudioStream(SDL_AudioDeviceID devid, SDL_AudioStream* stream);

	[CLink] public static extern void SDL_UnbindAudioStreams(SDL_AudioStream** streams, c_int num_streams);

	[CLink] public static extern void SDL_UnbindAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern SDL_AudioDeviceID SDL_GetAudioStreamDevice(SDL_AudioStream* stream);

	[CLink] public static extern SDL_AudioStream* SDL_CreateAudioStream(SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec);

	[CLink] public static extern SDL_PropertiesID SDL_GetAudioStreamProperties(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_GetAudioStreamFormat(SDL_AudioStream* stream, SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec);

	[CLink] public static extern c_bool SDL_SetAudioStreamFormat(SDL_AudioStream* stream, SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec);

	[CLink] public static extern float SDL_GetAudioStreamFrequencyRatio(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_SetAudioStreamFrequencyRatio(SDL_AudioStream* stream, float ratio);

	[CLink] public static extern float SDL_GetAudioStreamGain(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_SetAudioStreamGain(SDL_AudioStream* stream, float gain);

	[CLink] public static extern c_int*  SDL_GetAudioStreamInputChannelMap(SDL_AudioStream* stream, c_int* count);

	[CLink] public static extern c_int*  SDL_GetAudioStreamOutputChannelMap(SDL_AudioStream* stream, c_int* count);

	[CLink] public static extern c_bool SDL_SetAudioStreamInputChannelMap(SDL_AudioStream* stream, c_int* chmap, c_int count);

	[CLink] public static extern c_bool SDL_SetAudioStreamOutputChannelMap(SDL_AudioStream* stream, c_int* chmap, c_int count);

	[CLink] public static extern c_bool SDL_PutAudioStreamData(SDL_AudioStream* stream, void* buf, c_int len);

	[CLink] public static extern c_int SDL_GetAudioStreamData(SDL_AudioStream* stream, void* buf, c_int len);

	[CLink] public static extern c_int SDL_GetAudioStreamAvailable(SDL_AudioStream* stream);

	[CLink] public static extern c_int SDL_GetAudioStreamQueued(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_FlushAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_ClearAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_PauseAudioStreamDevice(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_ResumeAudioStreamDevice(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_AudioStreamDevicePaused(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_LockAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_UnlockAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern c_bool SDL_SetAudioStreamGetCallback(SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_SetAudioStreamPutCallback(SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userdata);

	[CLink] public static extern void SDL_DestroyAudioStream(SDL_AudioStream* stream);

	[CLink] public static extern SDL_AudioStream* SDL_OpenAudioDeviceStream(SDL_AudioDeviceID devid, SDL_AudioSpec* spec, SDL_AudioStreamCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_SetAudioPostmixCallback(SDL_AudioDeviceID devid, SDL_AudioPostmixCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_LoadWAV_IO(SDL_IOStream* src, c_bool closeio, SDL_AudioSpec* spec, uint8** audio_buf, uint32* audio_len);

	[CLink] public static extern c_bool SDL_LoadWAV(c_char* path, SDL_AudioSpec* spec, uint8** audio_buf, uint32* audio_len);

	[CLink] public static extern c_bool SDL_MixAudio(uint8* dst, uint8* src, SDL_AudioFormat format, uint32 len, float volume);

	[CLink] public static extern c_bool SDL_ConvertAudioSamples(SDL_AudioSpec* src_spec, uint8* src_data, c_int src_len, SDL_AudioSpec* dst_spec, uint8** dst_data, c_int* dst_len);

	[CLink] public static extern c_char* SDL_GetAudioFormatName(SDL_AudioFormat format);

	[CLink] public static extern c_int SDL_GetSilenceValueForFormat(SDL_AudioFormat format);

	//SDL_blendmode.h

	public enum SDL_BlendMode : uint32
	{
		SDL_BLENDMODE_NONE = 0x00000000u, /**< no blending: dstRGBA = srcRGBA */
		SDL_BLENDMODE_BLEND = 0x00000001u, /**< alpha blending: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)), dstA = srcA + (dstA * (1-srcA)) */
		SDL_BLENDMODE_BLEND_PREMULTIPLIED = 0x00000010u, /**< pre-multiplied alpha blending: dstRGBA = srcRGBA + (dstRGBA * (1-srcA)) */
		SDL_BLENDMODE_ADD = 0x00000002u, /**< additive blending: dstRGB = (srcRGB * srcA) + dstRGB, dstA = dstA */
		SDL_BLENDMODE_ADD_PREMULTIPLIED = 0x00000020u, /**< pre-multiplied additive blending: dstRGB = srcRGB + dstRGB, dstA = dstA */
		SDL_BLENDMODE_MOD = 0x00000004u, /**< color modulate: dstRGB = srcRGB * dstRGB, dstA = dstA */
		SDL_BLENDMODE_MUL = 0x00000008u, /**< color multiply: dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)), dstA = dstA */
		SDL_BLENDMODE_INVALID = 0x7FFFFFFFu,
	}

	public enum SDL_BlendFactor : c_int
	{
		SDL_BLENDFACTOR_ZERO = 0x1, /**< 0, 0, 0, 0 */
		SDL_BLENDFACTOR_ONE = 0x2, /**< 1, 1, 1, 1 */
		SDL_BLENDFACTOR_SRC_COLOR = 0x3, /**< srcR, srcG, srcB, srcA */
		SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = 0x4, /**< 1-srcR, 1-srcG, 1-srcB, 1-srcA */
		SDL_BLENDFACTOR_SRC_ALPHA = 0x5, /**< srcA, srcA, srcA, srcA */
		SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = 0x6, /**< 1-srcA, 1-srcA, 1-srcA, 1-srcA */
		SDL_BLENDFACTOR_DST_COLOR = 0x7, /**< dstR, dstG, dstB, dstA */
		SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = 0x8, /**< 1-dstR, 1-dstG, 1-dstB, 1-dstA */
		SDL_BLENDFACTOR_DST_ALPHA = 0x9, /**< dstA, dstA, dstA, dstA */
		SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = 0xA /**< 1-dstA, 1-dstA, 1-dstA, 1-dstA */
	}

	public enum SDL_BlendOperation : c_int
	{
		SDL_BLENDOPERATION_ADD              = 0x1, /**< dst + src: supported by all renderers */
		SDL_BLENDOPERATION_SUBTRACT         = 0x2, /**< src - dst : supported by D3D, OpenGL, OpenGLES, and Vulkan */
		SDL_BLENDOPERATION_REV_SUBTRACT     = 0x3, /**< dst - src : supported by D3D, OpenGL, OpenGLES, and Vulkan */
		SDL_BLENDOPERATION_MINIMUM          = 0x4, /**< min(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan */
		SDL_BLENDOPERATION_MAXIMUM          = 0x5 /**< max(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan */
	}

	[CLink] public static extern SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor, SDL_BlendFactor dstColorFactor, SDL_BlendOperation colorOperation, SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor, SDL_BlendOperation alphaOperation);

	//SDL_camera.h

	public typealias SDL_CameraID = uint32;

	[CRepr]
	public struct SDL_CameraSpec
	{
		public SDL_PixelFormat format; /**< Frame format */
		public SDL_Colorspace colorspace; /**< Frame colorspace */
		public c_int width; /**< Frame width */
		public c_int height; /**< Frame height */
		public c_int framerate_numerator; /**< Frame rate numerator ((num / denom) == FPS, (denom / num) == duration in seconds) */
		public c_int framerate_denominator; /**< Frame rate demoninator ((num / denom) == FPS, (denom / num) == duration in seconds) */
	}

	public enum SDL_CameraPosition : c_int
	{
		SDL_CAMERA_POSITION_UNKNOWN,
		SDL_CAMERA_POSITION_FRONT_FACING,
		SDL_CAMERA_POSITION_BACK_FACING
	}

	public struct SDL_Camera;

	[CLink] public static extern c_int SDL_GetNumCameraDrivers();

	[CLink] public static extern c_char* SDL_GetCameraDriver(c_int index);

	[CLink] public static extern c_char* SDL_GetCurrentCameraDriver();

	[CLink] public static extern SDL_CameraID* SDL_GetCameras(c_int* count);

	[CLink] public static extern SDL_CameraSpec** SDL_GetCameraSupportedFormats(SDL_CameraID devid, c_int* count);

	[CLink] public static extern c_char* SDL_GetCameraName(SDL_CameraID instance_id);

	[CLink] public static extern SDL_CameraPosition SDL_GetCameraPosition(SDL_CameraID instance_id);

	[CLink] public static extern SDL_Camera* SDL_OpenCamera(SDL_CameraID instance_id, SDL_CameraSpec* spec);

	[CLink] public static extern c_int SDL_GetCameraPermissionState(SDL_Camera* camera);

	[CLink] public static extern SDL_CameraID SDL_GetCameraID(SDL_Camera* camera);

	[CLink] public static extern SDL_PropertiesID SDL_GetCameraProperties(SDL_Camera* camera);

	[CLink] public static extern c_bool SDL_GetCameraFormat(SDL_Camera* camera, SDL_CameraSpec* spec);

	[CLink] public static extern SDL_Surface* SDL_AcquireCameraFrame(SDL_Camera* camera, uint64* timestampNS);

	[CLink] public static extern void SDL_ReleaseCameraFrame(SDL_Camera* camera, SDL_Surface* frame);

	[CLink] public static extern void SDL_CloseCamera(SDL_Camera* camera);

	//SDL_clipboard.h

	public typealias SDL_ClipboardDataCallback = function void*(void* userdata, c_char* mime_type, c_size* size);

	public typealias SDL_ClipboardCleanupCallback = function void(void* userdata);

	[CLink] public static extern c_bool SDL_SetClipboardText(c_char* text);

	[CLink] public static extern c_char* SDL_GetClipboardText();

	[CLink] public static extern c_bool SDL_HasClipboardText();

	[CLink] public static extern c_bool SDL_SetPrimarySelectionText(c_char* text);

	[CLink] public static extern c_char* SDL_GetPrimarySelectionText();

	[CLink] public static extern c_bool SDL_HasPrimarySelectionText();

	[CLink] public static extern c_bool SDL_SetClipboardData(SDL_ClipboardDataCallback callback, SDL_ClipboardCleanupCallback cleanup, void* userdata, c_char** mime_types, c_size num_mime_types);

	[CLink] public static extern c_bool SDL_ClearClipboardData();

	[CLink] public static extern void*  SDL_GetClipboardData(c_char* mime_type, c_size* size);

	[CLink] public static extern c_bool SDL_HasClipboardData(c_char* mime_type);

	[CLink] public static extern c_char** SDL_GetClipboardMimeTypes(c_size* num_mime_types);

	//SDL_cpuinfo.h

	public const uint32 SDL_CACHELINE_SIZE  = 128;

	[CLink] public static extern c_int SDL_GetNumLogicalCPUCores();

	[CLink] public static extern c_int SDL_GetCPUCacheLineSize();

	[CLink] public static extern c_bool SDL_HasAltiVec();

	[CLink] public static extern c_bool SDL_HasMMX();

	[CLink] public static extern c_bool SDL_HasSSE();

	[CLink] public static extern c_bool SDL_HasSSE2();

	[CLink] public static extern c_bool SDL_HasSSE3();

	[CLink] public static extern c_bool SDL_HasSSE41();

	[CLink] public static extern c_bool SDL_HasSSE42();

	[CLink] public static extern c_bool SDL_HasAVX();

	[CLink] public static extern c_bool SDL_HasAVX2();

	[CLink] public static extern c_bool SDL_HasAVX512F();

	[CLink] public static extern c_bool SDL_HasARMSIMD();

	[CLink] public static extern c_bool SDL_HasNEON();

	[CLink] public static extern c_bool SDL_HasLSX();

	[CLink] public static extern c_bool SDL_HasLASX();

	[CLink] public static extern c_int SDL_GetSystemRAM();

	[CLink] public static extern c_size SDL_GetSIMDAlignment();

	//SDL_dialog.h

	typealias SDL_DialogFileCallback = function void(void* userdate, c_char* filelist, c_int fiter);

	[CRepr]
	public struct SDL_DialogFileFilter
	{
		public c_char* name;
		public c_char* pattern;
	}

	public enum SDL_FileDialogType : c_int
	{
		SDL_FILEDIALOG_OPENFILE,
		SDL_FILEDIALOG_SAVEFILE,
		SDL_FILEDIALOG_OPENFOLDER
	}

	public const c_char* SDL_PROP_FILE_DIALOG_FILTERS_POINTER     = "SDL.filedialog.filters";
	public const c_char* SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER     = "SDL.filedialog.nfilters";
	public const c_char* SDL_PROP_FILE_DIALOG_WINDOW_POINTER      = "SDL.filedialog.window";
	public const c_char* SDL_PROP_FILE_DIALOG_LOCATION_STRING     = "SDL.filedialog.location";
	public const c_char* SDL_PROP_FILE_DIALOG_MANY_BOOLEAN        = "SDL.filedialog.many";
	public const c_char* SDL_PROP_FILE_DIALOG_TITLE_STRING        = "SDL.filedialog.title";
	public const c_char* SDL_PROP_FILE_DIALOG_ACCEPT_STRING       = "SDL.filedialog.accept";
	public const c_char* SDL_PROP_FILE_DIALOG_CANCEL_STRING       = "SDL.filedialog.cancel";

	[CLink] public static extern void SDL_ShowOpenFileDialog(SDL_DialogFileCallback callback, void* userdata, SDL_Window* window, SDL_DialogFileFilter* filters, c_int nfilters, c_char* default_location, c_bool allow_many);

	[CLink] public static extern void SDL_ShowSaveFileDialog(SDL_DialogFileCallback callback, void* userdata, SDL_Window* window, SDL_DialogFileFilter* filters, c_int nfilters, c_char* default_location);

	[CLink] public static extern void SDL_ShowOpenFolderDialog(SDL_DialogFileCallback callback, void* userdata, SDL_Window* window, c_char* default_location, c_bool allow_many);

	[CLink] public static extern void SDL_ShowFileDialogWithProperties(SDL_FileDialogType type, SDL_DialogFileCallback callback, void* userdata, SDL_PropertiesID props);

	//SDL_error.h

	[CLink] public static extern c_bool SDL_SetError(c_char* fmt, ...);

	[CLink] public static extern c_bool SDL_SetErrorV(c_char* fmt, VarArgs ap);

	[CLink] public static extern c_bool SDL_OutOfMemory();

	[CLink] public static extern c_char*  SDL_GetError();

	[CLink] public static extern c_bool SDL_ClearError();

	//SDL_events.h

	private static void Assert_SDL_Event_SIZE()
	{
		Compiler.Assert(sizeof(SDL_Event) == sizeof(decltype(((SDL_Event*)null).padding)));
	}

	[CRepr, Union]
	public struct SDL_Event
	{
		public uint32 type; /**< Event type, shared with all events, uint32 to cover user events which are not in the SDL_EventType enumeration */
		public SDL_CommonEvent common; /**< Common event data */
		public SDL_DisplayEvent display; /**< Display event data */
		public SDL_WindowEvent window; /**< Window event data */
		public SDL_KeyboardDeviceEvent kdevice; /**< Keyboard device change event data */
		public SDL_KeyboardEvent key; /**< Keyboard event data */
		public SDL_TextEditingEvent edit; /**< Text editing event data */
		public SDL_TextEditingCandidatesEvent edit_candidates; /**< Text editing candidates event data */
		public SDL_TextInputEvent text; /**< Text input event data */
		public SDL_MouseDeviceEvent mdevice; /**< Mouse device change event data */
		public SDL_MouseMotionEvent motion; /**< Mouse motion event data */
		public SDL_MouseButtonEvent button; /**< Mouse button event data */
		public SDL_MouseWheelEvent wheel; /**< Mouse wheel event data */
		public SDL_JoyDeviceEvent jdevice; /**< Joystick device change event data */
		public SDL_JoyAxisEvent jaxis; /**< Joystick axis event data */
		public SDL_JoyBallEvent jball; /**< Joystick ball event data */
		public SDL_JoyHatEvent jhat; /**< Joystick hat event data */
		public SDL_JoyButtonEvent jbutton; /**< Joystick button event data */
		public SDL_JoyBatteryEvent jbattery; /**< Joystick battery event data */
		public SDL_GamepadDeviceEvent gdevice; /**< Gamepad device event data */
		public SDL_GamepadAxisEvent gaxis; /**< Gamepad axis event data */
		public SDL_GamepadButtonEvent gbutton; /**< Gamepad button event data */
		public SDL_GamepadTouchpadEvent gtouchpad; /**< Gamepad touchpad event data */
		public SDL_GamepadSensorEvent gsensor; /**< Gamepad sensor event data */
		public SDL_AudioDeviceEvent adevice; /**< Audio device event data */
		public SDL_CameraDeviceEvent cdevice; /**< Camera device event data */
		public SDL_SensorEvent sensor; /**< Sensor event data */
		public SDL_QuitEvent quit; /**< Quit request event data */
		public SDL_UserEvent user; /**< Custom event data */
		public SDL_TouchFingerEvent tfinger; /**< Touch finger event data */
		public SDL_PenProximityEvent pproximity; /**< Pen proximity event data */
		public SDL_PenTouchEvent ptouch; /**< Pen tip touching event data */
		public SDL_PenMotionEvent pmotion; /**< Pen motion event data */
		public SDL_PenButtonEvent pbutton; /**< Pen button event data */
		public SDL_PenAxisEvent paxis; /**< Pen axis event data */
		public SDL_RenderEvent render; /**< Render event data */
		public SDL_DropEvent drop; /**< Drag and drop event data */
		public SDL_ClipboardEvent clipboard; /**< Clipboard event data */

		/* This is necessary for ABI compatibility between Visual C++ and GCC.
		   Visual C++ will respect the push pack pragma and use 52 bytes (size of
		   SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
		   architectures) for this union, and GCC will use the alignment of the
		   largest datatype within the union, which is 8 bytes on 64-bit
		   architectures.

		   So... we'll add padding to force the size to be the same for both.

		   On architectures where pointers are 16 bytes, this needs rounding up to
		   the next multiple of 16, 64, and on architectures where pointers are
		   even larger the size of SDL_UserEvent will dominate as being 3 pointers.
		*/
		public uint8[128] padding;
	}

	[CRepr] public struct SDL_RenderEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_RENDER_TARGETS_RESET, SDL_EVENT_RENDER_DEVICE_RESET, SDL_EVENT_RENDER_DEVICE_LOST */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window containing the renderer in question. */
	}

	[CRepr]
	public struct SDL_CommonEvent
	{
		public uint32 type; /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
	}

	[CRepr]
	public struct SDL_DisplayEvent
	{
		public SDL_EventType type; /**< SDL_DISPLAYEVENT_* */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_DisplayID displayID; /**< The associated display */
		public c_int data1; /**< event dependent data */
		public c_int data2; /**< event dependent data */
	}

	[CRepr]
	public struct SDL_WindowEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_WINDOW_* */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The associated window */
		public c_int data1; /**< event dependent data */
		public c_int data2; /**< event dependent data */
	}

	[CRepr]
	public struct SDL_KeyboardDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_KEYBOARD_ADDED or SDL_EVENT_KEYBOARD_REMOVED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_KeyboardID which; /**< The keyboard instance id */
	}

	[CRepr]
	public struct SDL_KeyboardEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_KEY_DOWN or SDL_EVENT_KEY_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with keyboard focus, if any */
		public SDL_KeyboardID which; /**< The keyboard instance id, or 0 if unknown or virtual */
		public SDL_Scancode scancode; /**< SDL physical key code */
		public SDL_Keycode key; /**< SDL virtual key code */
		public SDL_Keymod mod; /**< current key modifiers */
		public uint16 raw; /**< The platform dependent scancode for this event */
		public c_bool down; /**< true if the key is pressed */
		public c_bool repeat_; /**< true if this is a key repeat */
	}

	[CRepr]
	public struct SDL_TextEditingEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_TEXT_EDITING */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with keyboard focus, if any */
		public c_char* text; /**< The editing text */
		public c_int start; /**< The start cursor of selected editing text, or -1 if not set */
		public c_int length; /**< The length of selected editing text, or -1 if not set */
	}

	[CRepr]
	public struct SDL_TextEditingCandidatesEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_TEXT_EDITING_CANDIDATES */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with keyboard focus, if any */
		public c_char** candidates; /**< The list of candidates, or NULL if there are no candidates available */
		public c_int num_candidates; /**< The number of strings in `candidates` */
		public c_int selected_candidate; /**< The index of the selected candidate, or -1 if no candidate is selected */
		public c_bool horizontal; /**< true if the list is horizontal, false if it's vertical */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_TextInputEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_TEXT_INPUT */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with keyboard focus, if any */
		public c_char* text; /**< The input text, UTF-8 encoded */
	}

	[CRepr]
	public struct SDL_MouseDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_MOUSE_ADDED or SDL_EVENT_MOUSE_REMOVED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_MouseID which; /**< The mouse instance id */
	}

	[CRepr]
	public struct SDL_MouseMotionEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_MOUSE_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_MouseID which; /**< The mouse instance id or SDL_TOUCH_MOUSEID */
		public SDL_MouseButtonFlags state; /**< The current button state */
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
		public float xrel; /**< The relative motion in the X direction */
		public float yrel; /**< The relative motion in the Y direction */
	}

	[CRepr]
	public struct SDL_MouseButtonEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_MOUSE_BUTTON_DOWN or SDL_EVENT_MOUSE_BUTTON_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_MouseID which; /**< The mouse instance id, SDL_TOUCH_MOUSEID */
		public uint8 button; /**< The mouse button index */
		public c_bool down; /**< true if the button is pressed */
		public uint8 clicks; /**< 1 for single-click, 2 for double-click, etc. */
		public uint8 padding;
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
	}

	[CRepr]
	public struct SDL_MouseWheelEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_MOUSE_WHEEL */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_MouseID which; /**< The mouse instance id, SDL_TOUCH_MOUSEID */
		public float x; /**< The amount scrolled horizontally, positive to the right and negative to the left */
		public float y; /**< The amount scrolled vertically, positive away from the user and negative toward the user */
		public SDL_MouseWheelDirection direction; /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
		public float mouse_x; /**< X coordinate, relative to window */
		public float mouse_y; /**< Y coordinate, relative to window */
		public int32 integer_x; /**< The amount scrolled horizontally, accumulated to whole scroll "ticks" (added in 3.2.12) */
		public int32 integer_y; /**< The amount scrolled vertically, accumulated to whole scroll "ticks" (added in 3.2.12) */
	}

	[CRepr]
	public struct SDL_JoyDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_ADDED or SDL_EVENT_JOYSTICK_REMOVED or SDL_EVENT_JOYSTICK_UPDATE_COMPLETE */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
	}

	[CRepr]
	public struct SDL_JoyAxisEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_AXIS_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 axis; /**< The joystick axis index */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
		public int16 value; /**< The axis value (range: -32768 to 32767) */
		public uint16 padding4;
	}

	[CRepr]
	public struct SDL_JoyBallEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BALL_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 ball; /**< The joystick trackball index */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
		public int16 xrel; /**< The relative motion in the X direction */
		public int16 yrel; /**< The relative motion in the Y direction */
	}

	[CRepr]
	public struct SDL_JoyHatEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_HAT_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 hat; /**< The joystick hat index */
		public uint8 value; /**< The hat position value.
							 *   \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP
							 *   \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT
							 *   \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN
							 *
							 *   Note that zero means the POV is centered.
							 */
		public uint8 padding1;
		public uint8 padding2;
	}

	[CRepr]
	public struct SDL_JoyButtonEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BUTTON_DOWN or SDL_EVENT_JOYSTICK_BUTTON_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 button; /**< The joystick button index */
		public c_bool down; /**< true if the button is pressed */
		public uint8 padding1;
		public uint8 padding2;
	}

	[CRepr]
	public struct SDL_JoyBatteryEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BATTERY_UPDATED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public SDL_PowerState state; /**< The joystick battery state */
		public c_int percent; /**< The joystick battery percent c_charge remaining */
	}

	[CRepr]
	public struct SDL_GamepadDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_GAMEPAD_ADDED, SDL_EVENT_GAMEPAD_REMOVED, or SDL_EVENT_GAMEPAD_REMAPPED, SDL_EVENT_GAMEPAD_UPDATE_COMPLETE or SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
	}

	[CRepr]
	public struct SDL_GamepadAxisEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_GAMEPAD_AXIS_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 axis; /**< The gamepad axis (SDL_GamepadAxis) */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
		public int16 value; /**< The axis value (range: -32768 to 32767) */
		public uint16 padding4;
	}

	[CRepr]
	public struct SDL_GamepadButtonEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_GAMEPAD_BUTTON_DOWN or SDL_EVENT_GAMEPAD_BUTTON_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public uint8 button; /**< The gamepad button (SDL_GamepadButton) */
		public c_bool down; /**< true if the button is pressed */
		public uint8 padding1;
		public uint8 padding2;
	}

	[CRepr]
	public struct SDL_GamepadTouchpadEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN or SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION or SDL_EVENT_GAMEPAD_TOUCHPAD_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public c_int touchpad; /**< The index of the touchpad */
		public c_int finger; /**< The index of the finger on the touchpad */
		public float x; /**< Normalized in the range 0...1 with 0 being on the left */
		public float y; /**< Normalized in the range 0...1 with 0 being at the top */
		public float pressure; /**< Normalized in the range 0...1 */
	}

	[CRepr]
	public struct SDL_GamepadSensorEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_GAMEPAD_SENSOR_UPDATE */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_JoystickID which; /**< The joystick instance id */
		public c_int sensor; /**< The type of the sensor, one of the values of SDL_SensorType */
		public float[3] data; /**< Up to 3 values from the sensor, as defined in SDL_sensor.h */
		public uint64 sensor_timestamp; /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
	}

	[CRepr]
	public struct SDL_AudioDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_AUDIO_DEVICE_ADDED, or SDL_EVENT_AUDIO_DEVICE_REMOVED, or SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_AudioDeviceID which; /**< SDL_AudioDeviceID for the device being added or removed or changing */
		public c_bool recording; /**< false if a playback device, true if a recording device. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_CameraDeviceEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_CAMERA_DEVICE_ADDED, SDL_EVENT_CAMERA_DEVICE_REMOVED, SDL_EVENT_CAMERA_DEVICE_APPROVED, SDL_EVENT_CAMERA_DEVICE_DENIED */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_CameraID which; /**< SDL_CameraID for the device being added or removed or changing */
	}

	[CRepr]
	public struct SDL_SensorEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_SENSOR_UPDATE */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_SensorID which; /**< The instance ID of the sensor */
		public float[6] data; /**< Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData() */
		public uint64 sensor_timestamp; /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
	}

	[CRepr]
	public struct SDL_QuitEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_QUIT */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
	}

	[CRepr]
	public struct SDL_UserEvent
	{
		public uint32 type; /**< SDL_EVENT_USER through SDL_EVENT_LAST-1, Uint32 because these are not in the SDL_EventType enumeration */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The associated window if any */
		public c_int code; /**< User defined event code */
		public void* data1; /**< User defined data pointer */
		public void* data2; /**< User defined data pointer */
	}

	[CRepr]
	public struct SDL_TouchFingerEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_FINGER_MOTION or SDL_EVENT_FINGER_DOWN or SDL_EVENT_FINGER_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_TouchID touchID; /**< The touch device id */
		public SDL_FingerID fingerID;
		public float x; /**< Normalized in the range 0...1 */
		public float y; /**< Normalized in the range 0...1 */
		public float dx; /**< Normalized in the range -1...1 */
		public float dy; /**< Normalized in the range -1...1 */
		public float pressure; /**< Normalized in the range 0...1 */
		public SDL_WindowID windowID; /**< The window underneath the finger, if any */
	}

	[CRepr]
	public struct SDL_PenProximityEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_PEN_PROXIMITY_IN or SDL_EVENT_PEN_PROXIMITY_OUT */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_PenID which; /**< The pen instance id */
	}

	[CRepr]
	public struct SDL_PenTouchEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_PEN_DOWN or SDL_EVENT_PEN_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with pen focus, if any */
		public SDL_PenID which; /**< The pen instance id */
		public SDL_PenInputFlags pen_state; /**< Complete pen input state at time of event */
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
		public c_bool eraser; /**< true if eraser end is used (not all pens support this). */
		public c_bool down; /**< true if the pen is touching or false if the pen is lifted off */
	}

	[CRepr]
	public struct SDL_PenMotionEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_PEN_MOTION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_PenID which; /**< The pen instance id */
		public SDL_PenInputFlags pen_state; /**< Complete pen input state at time of event */
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
	}

	[CRepr]
	public struct SDL_PenButtonEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_PEN_BUTTON_DOWN or SDL_EVENT_PEN_BUTTON_UP */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with mouse focus, if any */
		public SDL_PenID which; /**< The pen instance id */
		public SDL_PenInputFlags pen_state; /**< Complete pen input state at time of event */
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
		public uint8 button; /**< The pen button index (first button is 1). */
		public c_bool down; /**< true if the button is pressed */
	}

	[CRepr]
	public struct SDL_PenAxisEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_PEN_AXIS */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window with pen focus, if any */
		public SDL_PenID which; /**< The pen instance id */
		public SDL_PenInputFlags pen_state; /**< Complete pen input state at time of event */
		public float x; /**< X coordinate, relative to window */
		public float y; /**< Y coordinate, relative to window */
		public SDL_PenAxis axis; /**< Axis that has changed */
		public float value; /**< New value of axis */
	}

	[CRepr]
	public struct SDL_DropEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_DROP_BEGIN or SDL_EVENT_DROP_FILE or SDL_EVENT_DROP_TEXT or SDL_EVENT_DROP_COMPLETE or SDL_EVENT_DROP_POSITION */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public SDL_WindowID windowID; /**< The window that was dropped on, if any */
		public float x; /**< X coordinate, relative to window (not on begin) */
		public float y; /**< Y coordinate, relative to window (not on begin) */
		public c_char* source; /**< The source app that sent this drop event, or NULL if that isn't available */
		public c_char* data; /**< The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events */
	}

	[CRepr]
	public struct SDL_ClipboardEvent
	{
		public SDL_EventType type; /**< SDL_EVENT_CLIPBOARD_UPDATE */
		public uint32 reserved;
		public uint64 timestamp; /**< In nanoseconds, populated using SDL_GetTicksNS() */
		public c_bool owner; /**< are we owning the clipboard (internal update) */
		public c_int n_mime_types; /**< number of mime types */
		public c_char** mime_types; /**< current mime types */
	}

	[AllowDuplicates]
	public enum SDL_EventType : c_int
	{
		SDL_EVENT_FIRST     = 0, /**< Unused (do not remove) */

		/* Application events */
		SDL_EVENT_QUIT           = 0x100, /**< User-requested quit */

		/* These application events have special meaning on iOS and Android, see README-ios.md and README-android.md for details */
		SDL_EVENT_TERMINATING, /**< The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationWillTerminate()
										 Called on Android in onDestroy()
									*/
		SDL_EVENT_LOW_MEMORY, /**< The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationDidReceiveMemoryWarning()
										 Called on Android in onTrimMemory()
									*/
		SDL_EVENT_WILL_ENTER_BACKGROUND, /**< The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationWillResignActive()
										 Called on Android in onPause()
									*/
		SDL_EVENT_DID_ENTER_BACKGROUND, /**< The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationDidEnterBackground()
										 Called on Android in onPause()
									*/
		SDL_EVENT_WILL_ENTER_FOREGROUND, /**< The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationWillEnterForeground()
										 Called on Android in onResume()
									*/
		SDL_EVENT_DID_ENTER_FOREGROUND, /**< The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
										 Called on iOS in applicationDidBecomeActive()
										 Called on Android in onResume()
									*/

		SDL_EVENT_LOCALE_CHANGED, /**< The user's locale preferences have changed. */

		SDL_EVENT_SYSTEM_THEME_CHANGED, /**< The system theme changed */

		/* Display events */
		/* 0x150 was SDL_DISPLAYEVENT, reserve the number for sdl2-compat */
		SDL_EVENT_DISPLAY_ORIENTATION = 0x151, /**< Display orientation has changed to data1 */
		SDL_EVENT_DISPLAY_ADDED, /**< Display has been added to the system */
		SDL_EVENT_DISPLAY_REMOVED, /**< Display has been removed from the system */
		SDL_EVENT_DISPLAY_MOVED, /**< Display has changed position */
		SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED, /**< Display has changed desktop mode */
		SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED, /**< Display has changed current mode */
		SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED, /**< Display has changed content scale */
		SDL_EVENT_DISPLAY_FIRST = SDL_EVENT_DISPLAY_ORIENTATION,
		SDL_EVENT_DISPLAY_LAST = SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED,

		/* Window events */
		/* 0x200 was SDL_WINDOWEVENT, reserve the number for sdl2-compat */
		/* 0x201 was SDL_EVENT_SYSWM, reserve the number for sdl2-compat */
		SDL_EVENT_WINDOW_SHOWN = 0x202, /**< Window has been shown */
		SDL_EVENT_WINDOW_HIDDEN, /**< Window has been hidden */
		SDL_EVENT_WINDOW_EXPOSED, /**< Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event */
		SDL_EVENT_WINDOW_MOVED, /**< Window has been moved to data1, data2 */
		SDL_EVENT_WINDOW_RESIZED, /**< Window has been resized to data1xdata2 */
		SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED, /**< The pixel size of the window has changed to data1xdata2 */
		SDL_EVENT_WINDOW_METAL_VIEW_RESIZED, /**< The pixel size of a Metal view associated with the window has changed */
		SDL_EVENT_WINDOW_MINIMIZED, /**< Window has been minimized */
		SDL_EVENT_WINDOW_MAXIMIZED, /**< Window has been maximized */
		SDL_EVENT_WINDOW_RESTORED, /**< Window has been restored to normal size and position */
		SDL_EVENT_WINDOW_MOUSE_ENTER, /**< Window has gained mouse focus */
		SDL_EVENT_WINDOW_MOUSE_LEAVE, /**< Window has lost mouse focus */
		SDL_EVENT_WINDOW_FOCUS_GAINED, /**< Window has gained keyboard focus */
		SDL_EVENT_WINDOW_FOCUS_LOST, /**< Window has lost keyboard focus */
		SDL_EVENT_WINDOW_CLOSE_REQUESTED, /**< The window manager requests that the window be closed */
		SDL_EVENT_WINDOW_HIT_TEST, /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL */
		SDL_EVENT_WINDOW_ICCPROF_CHANGED, /**< The ICC profile of the window's display has changed */
		SDL_EVENT_WINDOW_DISPLAY_CHANGED, /**< Window has been moved to display data1 */
		SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED, /**< Window display scale has been changed */
		SDL_EVENT_WINDOW_SAFE_AREA_CHANGED, /**< The window safe area has been changed */
		SDL_EVENT_WINDOW_OCCLUDED, /**< The window has been occluded */
		SDL_EVENT_WINDOW_ENTER_FULLSCREEN, /**< The window has entered fullscreen mode */
		SDL_EVENT_WINDOW_LEAVE_FULLSCREEN, /**< The window has left fullscreen mode */
		SDL_EVENT_WINDOW_DESTROYED, /**< The window with the associated ID is being or has been destroyed. If this message is being handled
												 in an event watcher, the window handle is still valid and can still be used to retrieve any properties
												 associated with the window. Otherwise, the handle has already been destroyed and all resources
												 associated with it are invalid */
		SDL_EVENT_WINDOW_HDR_STATE_CHANGED, /**< Window HDR properties have changed */
		SDL_EVENT_WINDOW_FIRST = SDL_EVENT_WINDOW_SHOWN,
		SDL_EVENT_WINDOW_LAST = SDL_EVENT_WINDOW_HDR_STATE_CHANGED,

		/* Keyboard events */
		SDL_EVENT_KEY_DOWN        = 0x300, /**< Key pressed */
		SDL_EVENT_KEY_UP, /**< Key released */
		SDL_EVENT_TEXT_EDITING, /**< Keyboard text editing (composition) */
		SDL_EVENT_TEXT_INPUT, /**< Keyboard text input */
		SDL_EVENT_KEYMAP_CHANGED, /**< Keymap changed due to a system event such as an
												input language or keyboard layout change. */
		SDL_EVENT_KEYBOARD_ADDED, /**< A new keyboard has been inserted into the system */
		SDL_EVENT_KEYBOARD_REMOVED, /**< A keyboard has been removed */
		SDL_EVENT_TEXT_EDITING_CANDIDATES, /**< Keyboard text editing candidates */

		/* Mouse events */
		SDL_EVENT_MOUSE_MOTION    = 0x400, /**< Mouse moved */
		SDL_EVENT_MOUSE_BUTTON_DOWN, /**< Mouse button pressed */
		SDL_EVENT_MOUSE_BUTTON_UP, /**< Mouse button released */
		SDL_EVENT_MOUSE_WHEEL, /**< Mouse wheel motion */
		SDL_EVENT_MOUSE_ADDED, /**< A new mouse has been inserted into the system */
		SDL_EVENT_MOUSE_REMOVED, /**< A mouse has been removed */

		/* Joystick events */
		SDL_EVENT_JOYSTICK_AXIS_MOTION  = 0x600, /**< Joystick axis motion */
		SDL_EVENT_JOYSTICK_BALL_MOTION, /**< Joystick trackball motion */
		SDL_EVENT_JOYSTICK_HAT_MOTION, /**< Joystick hat position change */
		SDL_EVENT_JOYSTICK_BUTTON_DOWN, /**< Joystick button pressed */
		SDL_EVENT_JOYSTICK_BUTTON_UP, /**< Joystick button released */
		SDL_EVENT_JOYSTICK_ADDED, /**< A new joystick has been inserted into the system */
		SDL_EVENT_JOYSTICK_REMOVED, /**< An opened joystick has been removed */
		SDL_EVENT_JOYSTICK_BATTERY_UPDATED, /**< Joystick battery level change */
		SDL_EVENT_JOYSTICK_UPDATE_COMPLETE, /**< Joystick update is complete */

		/* Gamepad events */
		SDL_EVENT_GAMEPAD_AXIS_MOTION  = 0x650, /**< Gamepad axis motion */
		SDL_EVENT_GAMEPAD_BUTTON_DOWN, /**< Gamepad button pressed */
		SDL_EVENT_GAMEPAD_BUTTON_UP, /**< Gamepad button released */
		SDL_EVENT_GAMEPAD_ADDED, /**< A new gamepad has been inserted into the system */
		SDL_EVENT_GAMEPAD_REMOVED, /**< A gamepad has been removed */
		SDL_EVENT_GAMEPAD_REMAPPED, /**< The gamepad mapping was updated */
		SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN, /**< Gamepad touchpad was touched */
		SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION, /**< Gamepad touchpad finger was moved */
		SDL_EVENT_GAMEPAD_TOUCHPAD_UP, /**< Gamepad touchpad finger was lifted */
		SDL_EVENT_GAMEPAD_SENSOR_UPDATE, /**< Gamepad sensor was updated */
		SDL_EVENT_GAMEPAD_UPDATE_COMPLETE, /**< Gamepad update is complete */
		SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED, /**< Gamepad Steam handle has changed */

		/* Touch events */
		SDL_EVENT_FINGER_DOWN      = 0x700,
		SDL_EVENT_FINGER_UP,
		SDL_EVENT_FINGER_MOTION,
		SDL_EVENT_FINGER_CANCELED,

		/* 0x800, 0x801, and 0x802 were the Gesture events from SDL2. Do not reuse these values! sdl2-compat needs them! */

		/* Clipboard events */
		SDL_EVENT_CLIPBOARD_UPDATE = 0x900, /**< The clipboard or primary selection changed */

		/* Drag and drop events */
		SDL_EVENT_DROP_FILE        = 0x1000, /**< The system requests a file open */
		SDL_EVENT_DROP_TEXT, /**< text/plain drag-and-drop event */
		SDL_EVENT_DROP_BEGIN, /**< A new set of drops is beginning (NULL filename) */
		SDL_EVENT_DROP_COMPLETE, /**< Current set of drops is now complete (NULL filename) */
		SDL_EVENT_DROP_POSITION, /**< Position while moving over the window */

		/* Audio hotplug events */
		SDL_EVENT_AUDIO_DEVICE_ADDED = 0x1100, /**< A new audio device is available */
		SDL_EVENT_AUDIO_DEVICE_REMOVED, /**< An audio device has been removed. */
		SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED, /**< An audio device's format has been changed by the system. */

		/* Sensor events */
		SDL_EVENT_SENSOR_UPDATE = 0x1200, /**< A sensor was updated */

		/* Pressure-sensitive pen events */
		SDL_EVENT_PEN_PROXIMITY_IN = 0x1300, /**< Pressure-sensitive pen has become available */
		SDL_EVENT_PEN_PROXIMITY_OUT, /**< Pressure-sensitive pen has become unavailable */
		SDL_EVENT_PEN_DOWN, /**< Pressure-sensitive pen touched drawing surface */
		SDL_EVENT_PEN_UP, /**< Pressure-sensitive pen stopped touching drawing surface */
		SDL_EVENT_PEN_BUTTON_DOWN, /**< Pressure-sensitive pen button pressed */
		SDL_EVENT_PEN_BUTTON_UP, /**< Pressure-sensitive pen button released */
		SDL_EVENT_PEN_MOTION, /**< Pressure-sensitive pen is moving on the tablet */
		SDL_EVENT_PEN_AXIS, /**< Pressure-sensitive pen angle/pressure/etc changed */

		/* Camera hotplug events */
		SDL_EVENT_CAMERA_DEVICE_ADDED = 0x1400, /**< A new camera device is available */
		SDL_EVENT_CAMERA_DEVICE_REMOVED, /**< A camera device has been removed. */
		SDL_EVENT_CAMERA_DEVICE_APPROVED, /**< A camera device has been approved for use by the user. */
		SDL_EVENT_CAMERA_DEVICE_DENIED, /**< A camera device has been denied for use by the user. */

		/* Render events */
		SDL_EVENT_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
		SDL_EVENT_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */
		SDL_EVENT_RENDER_DEVICE_LOST, /**< The device has been lost and can't be recovered. */

		/* Reserved events for private platforms */
		SDL_EVENT_PRIVATE0 = 0x4000,
		SDL_EVENT_PRIVATE1,
		SDL_EVENT_PRIVATE2,
		SDL_EVENT_PRIVATE3,

		/* Internal events */
		SDL_EVENT_POLL_SENTINEL = 0x7F00, /**< Signals the end of an event poll cycle */

		/** Events SDL_EVENT_USER through SDL_EVENT_LAST are for your use,
		 *  and should be allocated with SDL_RegisterEvents()
		 */
		SDL_EVENT_USER    = 0x8000,

		/**
		 *  This last event is only for bounding internal arrays
		 */
		SDL_EVENT_LAST    = 0xFFFF,

		/* This just makes sure the enum is the size of uint32 */
		SDL_EVENT_ENUM_PADDING = 0x7FFFFFFF

	}

	public enum SDL_EventAction : c_int
	{
		SDL_ADDEVENT, /**< Add events to the back of the queue. */
		SDL_PEEKEVENT, /**< Check but don't remove events from the queue front. */
		SDL_GETEVENT /**< Retrieve/remove events from the front of the queue. */
	}

	public typealias SDL_EventFilter = function c_bool(void* userdata, SDL_Event* event);

	[CLink] public static extern void SDL_PumpEvents();

	[CLink] public static extern c_int SDL_PeepEvents(SDL_Event* events, c_int numevents, SDL_EventAction action, uint32 minType, uint32 maxType);

	[CLink] public static extern c_bool SDL_HasEvent(uint32 type);

	[CLink] public static extern c_bool SDL_HasEvents(uint32 minType, uint32 maxType);

	[CLink] public static extern void SDL_FlushEvent(uint32 type);

	[CLink] public static extern void SDL_FlushEvents(uint32 minType, uint32 maxType);

	[CLink] public static extern c_bool SDL_PollEvent(SDL_Event* event);

	[CLink] public static extern c_bool SDL_WaitEvent(SDL_Event* event);

	[CLink] public static extern c_bool SDL_WaitEventTimeout(SDL_Event* event, c_int timeoutMS);

	[CLink] public static extern c_bool SDL_PushEvent(SDL_Event* event);

	[CLink] public static extern void SDL_SetEventFilter(SDL_EventFilter filter, void* userdata);

	[CLink] public static extern c_bool SDL_GetEventFilter(SDL_EventFilter* filter, void** userdata);

	[CLink] public static extern c_bool SDL_AddEventWatch(SDL_EventFilter filter, void* userdata);

	[CLink] public static extern void SDL_RemoveEventWatch(SDL_EventFilter filter, void* userdata);

	[CLink] public static extern void SDL_FilterEvents(SDL_EventFilter filter, void* userdata);

	[CLink] public static extern void SDL_SetEventEnabled(uint32 type, c_bool enabled);

	[CLink] public static extern c_bool SDL_EventEnabled(uint32 type);

	[CLink] public static extern uint32 SDL_RegisterEvents(c_int numevents);

	[CLink] public static extern SDL_Window* SDL_GetWindowFromEvent(SDL_Event* event);

	//SDL_filesystem.h

	public enum SDL_Folder : c_int
	{
		SDL_FOLDER_HOME, /**< The folder which contains all of the current user's data, preferences, and documents. It usually contains most of the other folders. If a requested folder does not exist, the home folder can be considered a safe fallback to store a user's documents. */

		SDL_FOLDER_DESKTOP, /**< The folder of files that are displayed on the desktop. Note that the existence of a desktop folder does not guarantee that the system does show icons on its desktop; certain GNU/Linux distros with a graphical environment may not have desktop icons. */

		SDL_FOLDER_DOCUMENTS, /**< User document files, possibly application-specific. This is a good place to save a user's projects. */

		SDL_FOLDER_DOWNLOADS, /**< Standard folder for user files downloaded from the internet. */

		SDL_FOLDER_MUSIC, /**< Music files that can be played using a standard music player (mp3, ogg...). */

		SDL_FOLDER_PICTURES, /**< Image files that can be displayed using a standard viewer (png, jpg...). */

		SDL_FOLDER_PUBLICSHARE, /**< Files that are meant to be shared with other users on the same computer. */

		SDL_FOLDER_SAVEDGAMES, /**< Save files for games. */

		SDL_FOLDER_SCREENSHOTS, /**< Application screenshots. */

		SDL_FOLDER_TEMPLATES, /**< Template files to be used when the user requests the desktop environment to create a new file in a certain folder, such as "New Text File.txt".  Any file in the Templates folder can be used as a starting poc_intfor a new file. */

		SDL_FOLDER_VIDEOS, /**< Video files that can be played using a standard video player (mp4, webm...). */

		SDL_FOLDER_COUNT /**< Total number of types in this enum, not a folder type by itself. */
	}

	public typealias SDL_EnumerateDirectoryCallback = function SDL_EnumerationResult(void* userdate, c_char* dirname, c_char* fname);

	public enum SDL_EnumerationResult : c_int
	{
		SDL_ENUM_CONTINUE, /**< Value that requests that enumeration continue. */
		SDL_ENUM_SUCCESS, /**< Value that requests that enumeration stop, successfully. */
		SDL_ENUM_FAILURE /**< Value that requests that enumeration stop, as a failure. */
	}

	public typealias SDL_GlobFlags = uint32;

	public const uint32 SDL_GLOB_CASEINSENSITIVE  = (1 << 0);

	[CRepr]
	public struct SDL_PathInfo
	{
		public SDL_PathType type; /**< the path type */
		public int64 size; /**< the file size in bytes */
		public SDL_Time create_time; /**< the time when the path was created */
		public SDL_Time modify_time; /**< the last time the path was modified */
		public SDL_Time access_time; /**< the last time the path was read */
	}

	public enum SDL_PathType : c_int
	{
		SDL_PATHTYPE_NONE, /**< path does not exist */
		SDL_PATHTYPE_FILE, /**< a normal file */
		SDL_PATHTYPE_DIRECTORY, /**< a directory */
		SDL_PATHTYPE_OTHER /**< something completely different like a device node (not a symlink, those are always followed) */
	}

	[CLink] public static extern c_char* SDL_GetBasePath();

	[CLink] public static extern c_char* SDL_GetPrefPath(c_char* org, c_char* app);

	[CLink] public static extern c_char* SDL_GetUserFolder(SDL_Folder folder);

	[CLink] public static extern c_bool SDL_CreateDirectory(c_char* path);

	[CLink] public static extern c_bool SDL_EnumerateDirectory(c_char* path, SDL_EnumerateDirectoryCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_RemovePath(c_char* path);

	[CLink] public static extern c_bool SDL_RenamePath(c_char* oldpath, c_char* newpath);

	[CLink] public static extern c_bool SDL_CopyFile(c_char* oldpath, c_char* newpath);

	[CLink] public static extern c_bool SDL_GetPathInfo(c_char* path, SDL_PathInfo* info);

	[CLink] public static extern c_char** SDL_GlobDirectory(c_char* path, c_char* pattern, SDL_GlobFlags flags, c_int* count);

	[CLink] public static extern c_char*  SDL_GetCurrentDirectory();

	//SDL_gamepad.h

	public struct SDL_Gamepad;

	public enum SDL_GamepadType : c_int
	{
		SDL_GAMEPAD_TYPE_UNKNOWN = 0,
		SDL_GAMEPAD_TYPE_STANDARD,
		SDL_GAMEPAD_TYPE_XBOX360,
		SDL_GAMEPAD_TYPE_XBOXONE,
		SDL_GAMEPAD_TYPE_PS3,
		SDL_GAMEPAD_TYPE_PS4,
		SDL_GAMEPAD_TYPE_PS5,
		SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO,
		SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT,
		SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT,
		SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR,
		SDL_GAMEPAD_TYPE_COUNT
	}

	[CRepr]
	public struct SDL_GamepadBinding
	{
		public SDL_GamepadBindingType input_type;
		public _InputUnion input;
		public SDL_GamepadBindingType output_type;
		public _OutputUnion output;

		[CRepr, Union]
		public struct _InputUnion
		{
			public c_int button;
			public _InputUnionAxis axis;
			public _InputUnionAxis hat;

			[CRepr]
			public struct _InputUnionAxis
			{
				public c_int axis;
				public c_int axis_min;
				public c_int axis_max;
			}

			[CRepr]
			public struct _InputUnionHat
			{
				public c_int hat;
				public c_int hat_mask;
			}
		}

		[CRepr, Union]
		public struct _OutputUnion
		{
			public SDL_GamepadButton button;
			public _OutputUnionAxis axis;

			[CRepr]
			public struct _OutputUnionAxis
			{
				public SDL_GamepadAxis axis;
				public c_int axis_min;
				public c_int axis_max;
			}
		}
	}

	public enum SDL_GamepadAxis : c_int
	{
		SDL_GAMEPAD_AXIS_INVALID = -1,
		SDL_GAMEPAD_AXIS_LEFTX,
		SDL_GAMEPAD_AXIS_LEFTY,
		SDL_GAMEPAD_AXIS_RIGHTX,
		SDL_GAMEPAD_AXIS_RIGHTY,
		SDL_GAMEPAD_AXIS_LEFT_TRIGGER,
		SDL_GAMEPAD_AXIS_RIGHT_TRIGGER,
		SDL_GAMEPAD_AXIS_COUNT
	}

	public enum SDL_GamepadButton : c_int
	{
		SDL_GAMEPAD_BUTTON_INVALID = -1,
		SDL_GAMEPAD_BUTTON_SOUTH, /**< Bottom face button (e.g. Xbox A button) */
		SDL_GAMEPAD_BUTTON_EAST, /**< Right face button (e.g. Xbox B button) */
		SDL_GAMEPAD_BUTTON_WEST, /**< Left face button (e.g. Xbox X button) */
		SDL_GAMEPAD_BUTTON_NORTH, /**< Top face button (e.g. Xbox Y button) */
		SDL_GAMEPAD_BUTTON_BACK,
		SDL_GAMEPAD_BUTTON_GUIDE,
		SDL_GAMEPAD_BUTTON_START,
		SDL_GAMEPAD_BUTTON_LEFT_STICK,
		SDL_GAMEPAD_BUTTON_RIGHT_STICK,
		SDL_GAMEPAD_BUTTON_LEFT_SHOULDER,
		SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER,
		SDL_GAMEPAD_BUTTON_DPAD_UP,
		SDL_GAMEPAD_BUTTON_DPAD_DOWN,
		SDL_GAMEPAD_BUTTON_DPAD_LEFT,
		SDL_GAMEPAD_BUTTON_DPAD_RIGHT,
		SDL_GAMEPAD_BUTTON_MISC1, /**< Additional button (e.g. Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button, Google Stadia capture button) */
		SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1, /**< Upper or primary paddle, under your right hand (e.g. Xbox Elite paddle P1) */
		SDL_GAMEPAD_BUTTON_LEFT_PADDLE1, /**< Upper or primary paddle, under your left hand (e.g. Xbox Elite paddle P3) */
		SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2, /**< Lower or secondary paddle, under your right hand (e.g. Xbox Elite paddle P2) */
		SDL_GAMEPAD_BUTTON_LEFT_PADDLE2, /**< Lower or secondary paddle, under your left hand (e.g. Xbox Elite paddle P4) */
		SDL_GAMEPAD_BUTTON_TOUCHPAD, /**< PS4/PS5 touchpad button */
		SDL_GAMEPAD_BUTTON_MISC2, /**< Additional button */
		SDL_GAMEPAD_BUTTON_MISC3, /**< Additional button */
		SDL_GAMEPAD_BUTTON_MISC4, /**< Additional button */
		SDL_GAMEPAD_BUTTON_MISC5, /**< Additional button */
		SDL_GAMEPAD_BUTTON_MISC6, /**< Additional button */
		SDL_GAMEPAD_BUTTON_COUNT
	}

	public enum SDL_GamepadButtonLabel : c_int
	{
		SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN,
		SDL_GAMEPAD_BUTTON_LABEL_A,
		SDL_GAMEPAD_BUTTON_LABEL_B,
		SDL_GAMEPAD_BUTTON_LABEL_X,
		SDL_GAMEPAD_BUTTON_LABEL_Y,
		SDL_GAMEPAD_BUTTON_LABEL_CROSS,
		SDL_GAMEPAD_BUTTON_LABEL_CIRCLE,
		SDL_GAMEPAD_BUTTON_LABEL_SQUARE,
		SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE
	}

	public enum SDL_GamepadBindingType : c_int
	{
		SDL_GAMEPAD_BINDTYPE_NONE = 0,
		SDL_GAMEPAD_BINDTYPE_BUTTON,
		SDL_GAMEPAD_BINDTYPE_AXIS,
		SDL_GAMEPAD_BINDTYPE_HAT
	}

	public const c_char* SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN       = SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN;
	public const c_char* SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN        = SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN;
	public const c_char* SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN     = SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN;
	public const c_char* SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN         = SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN;
	public const c_char* SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN = SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN;

	[CLink] public static extern c_int SDL_AddGamepadMapping(c_char* mapping);

	[CLink] public static extern c_int SDL_AddGamepadMappingsFromIO(SDL_IOStream* src, c_bool closeio);

	[CLink] public static extern c_int SDL_AddGamepadMappingsFromFile(c_char* file);

	[CLink] public static extern c_bool SDL_ReloadGamepadMappings();

	[CLink] public static extern c_char** SDL_GetGamepadMappings(c_int* count);

	[CLink] public static extern c_char* SDL_GetGamepadMappingForGUID(SDL_GUID guid);

	[CLink] public static extern c_char* SDL_GetGamepadMapping(SDL_Gamepad* gamepad);

	[CLink] public static extern c_bool SDL_SetGamepadMapping(SDL_JoystickID instance_id, c_char* mapping);

	[CLink] public static extern c_bool SDL_HasGamepad();

	[CLink] public static extern SDL_JoystickID* SDL_GetGamepads(c_int* count);

	[CLink] public static extern c_bool SDL_IsGamepad(SDL_JoystickID instance_id);

	[CLink] public static extern c_char* SDL_GetGamepadNameForID(SDL_JoystickID instance_id);

	[CLink] public static extern c_char* SDL_GetGamepadPathForID(SDL_JoystickID instance_id);

	[CLink] public static extern c_int SDL_GetGamepadPlayerIndexForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_GUID SDL_GetGamepadGUIDForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetGamepadVendorForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetGamepadProductForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetGamepadProductVersionForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_GamepadType SDL_GetGamepadTypeForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_GamepadType SDL_GetRealGamepadTypeForID(SDL_JoystickID instance_id);

	[CLink] public static extern c_char* SDL_GetGamepadMappingForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Gamepad* SDL_OpenGamepad(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Gamepad* SDL_GetGamepadFromID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Gamepad* SDL_GetGamepadFromPlayerIndex(c_int player_index);

	[CLink] public static extern SDL_PropertiesID SDL_GetGamepadProperties(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_JoystickID SDL_GetGamepadID(SDL_Gamepad* gamepad);

	[CLink] public static extern c_char* SDL_GetGamepadName(SDL_Gamepad* gamepad);

	[CLink] public static extern c_char* SDL_GetGamepadPath(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_GamepadType SDL_GetGamepadType(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_GamepadType SDL_GetRealGamepadType(SDL_Gamepad* gamepad);

	[CLink] public static extern c_int SDL_GetGamepadPlayerIndex(SDL_Gamepad* gamepad);

	[CLink] public static extern c_bool SDL_SetGamepadPlayerIndex(SDL_Gamepad* gamepad, c_int player_index);

	[CLink] public static extern uint16 SDL_GetGamepadVendor(SDL_Gamepad* gamepad);

	[CLink] public static extern uint16 SDL_GetGamepadProduct(SDL_Gamepad* gamepad);

	[CLink] public static extern uint16 SDL_GetGamepadProductVersion(SDL_Gamepad* gamepad);

	[CLink] public static extern uint16 SDL_GetGamepadFirmwareVersion(SDL_Gamepad* gamepad);

	[CLink] public static extern c_char* SDL_GetGamepadSerial(SDL_Gamepad* gamepad);

	[CLink] public static extern uint64 SDL_GetGamepadSteamHandle(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_JoystickConnectionState SDL_GetGamepadConnectionState(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_PowerState SDL_GetGamepadPowerInfo(SDL_Gamepad* gamepad, c_int* percent);

	[CLink] public static extern c_bool SDL_GamepadConnected(SDL_Gamepad* gamepad);

	[CLink] public static extern SDL_Joystick* SDL_GetGamepadJoystick(SDL_Gamepad* gamepad);

	[CLink] public static extern void SDL_SetGamepadEventsEnabled(c_bool enabled);

	[CLink] public static extern c_bool SDL_GamepadEventsEnabled();

	[CLink] public static extern SDL_GamepadBinding** SDL_GetGamepadBindings(SDL_Gamepad* gamepad, c_int* count);

	[CLink] public static extern void SDL_UpdateGamepads();

	[CLink] public static extern SDL_GamepadType SDL_GetGamepadTypeFromString(c_char* str);

	[CLink] public static extern c_char* SDL_GetGamepadStringForType(SDL_GamepadType type);

	[CLink] public static extern SDL_GamepadAxis SDL_GetGamepadAxisFromString(c_char* str);

	[CLink] public static extern c_char* SDL_GetGamepadStringForAxis(SDL_GamepadAxis axis);

	[CLink] public static extern c_bool SDL_GamepadHasAxis(SDL_Gamepad* gamepad, SDL_GamepadAxis axis);

	[CLink] public static extern int16 SDL_GetGamepadAxis(SDL_Gamepad* gamepad, SDL_GamepadAxis axis);

	[CLink] public static extern SDL_GamepadButton SDL_GetGamepadButtonFromString(c_char* str);

	[CLink] public static extern c_char* SDL_GetGamepadStringForButton(SDL_GamepadButton button);

	[CLink] public static extern c_bool SDL_GamepadHasButton(SDL_Gamepad* gamepad, SDL_GamepadButton button);

	[CLink] public static extern c_bool SDL_GetGamepadButton(SDL_Gamepad* gamepad, SDL_GamepadButton button);

	[CLink] public static extern SDL_GamepadButtonLabel SDL_GetGamepadButtonLabelForType(SDL_GamepadType type, SDL_GamepadButton button);

	[CLink] public static extern SDL_GamepadButtonLabel SDL_GetGamepadButtonLabel(SDL_Gamepad* gamepad, SDL_GamepadButton button);

	[CLink] public static extern c_int SDL_GetNumGamepadTouchpads(SDL_Gamepad* gamepad);

	[CLink] public static extern c_int SDL_GetNumGamepadTouchpadFingers(SDL_Gamepad* gamepad, c_int touchpad);

	[CLink] public static extern c_bool SDL_GetGamepadTouchpadFinger(SDL_Gamepad* gamepad, c_int touchpad, c_int finger, c_bool* down, float* x, float* y, float* pressure);

	[CLink] public static extern c_bool SDL_GamepadHasSensor(SDL_Gamepad* gamepad, SDL_SensorType type);

	[CLink] public static extern c_bool SDL_SetGamepadSensorEnabled(SDL_Gamepad* gamepad, SDL_SensorType type, c_bool enabled);

	[CLink] public static extern c_bool SDL_GamepadSensorEnabled(SDL_Gamepad* gamepad, SDL_SensorType type);

	[CLink] public static extern float SDL_GetGamepadSensorDataRate(SDL_Gamepad* gamepad, SDL_SensorType type);

	[CLink] public static extern c_bool SDL_GetGamepadSensorData(SDL_Gamepad* gamepad, SDL_SensorType type, float* data, c_int num_values);

	[CLink] public static extern c_bool SDL_RumbleGamepad(SDL_Gamepad* gamepad, uint16 low_frequency_rumble, uint16 high_frequency_rumble, uint32 duration_ms);

	[CLink] public static extern c_bool SDL_RumbleGamepadTriggers(SDL_Gamepad* gamepad, uint16 left_rumble, uint16 right_rumble, uint32 duration_ms);

	[CLink] public static extern c_bool SDL_SetGamepadLED(SDL_Gamepad* gamepad, uint8 red, uint8 green, uint8 blue);

	[CLink] public static extern c_bool SDL_SendGamepadEffect(SDL_Gamepad* gamepad, void* data, c_int size);

	[CLink] public static extern void SDL_CloseGamepad(SDL_Gamepad* gamepad);

	[CLink] public static extern c_char* SDL_GetGamepadAppleSFSymbolsNameForButton(SDL_Gamepad* gamepad, SDL_GamepadButton button);

	[CLink] public static extern c_char* SDL_GetGamepadAppleSFSymbolsNameForAxis(SDL_Gamepad* gamepad, SDL_GamepadAxis axis);

	//SDL_gpu.h

	public enum SDL_GPUShaderFormat : uint32
	{
		SDL_GPU_SHADERFORMAT_INVALID  = 0,
		SDL_GPU_SHADERFORMAT_PRIVATE  = (1u << 0), /**< Shaders for NDA'd platforms. */
		SDL_GPU_SHADERFORMAT_SPIRV    = (1u << 1), /**< SPIR-V shaders for Vulkan. */
		SDL_GPU_SHADERFORMAT_DXBC     = (1u << 2), /**< DXBC SM5_0 shaders for D3D11. */
		SDL_GPU_SHADERFORMAT_DXIL     = (1u << 3), /**< DXIL shaders for D3D12. */
		SDL_GPU_SHADERFORMAT_MSL      = (1u << 4), /**< MSL shaders for Metal. */
		SDL_GPU_SHADERFORMAT_METALLIB = (1u << 5), /**< Precompiled metallib shaders for Metal. */
	}

	[CRepr]
	public struct SDL_GPUDevice;

	[CRepr]
	public struct SDL_GPUComputePipeline;

	[CRepr]
	public struct SDL_GPUComputePipelineCreateInfo
	{
		public c_size code_size; /**< The size in bytes of the compute shader code pointed to. */
		public uint8* code; /**< A pointer to compute shader code. */
		public c_char* entrypoint; /**< A pointer to a null-terminated UTF-8 string specifying the entry poc_intfunction name for the shader. */
		public SDL_GPUShaderFormat format; /**< The format of the compute shader code. */
		public uint32 num_samplers; /**< The number of samplers defined in the shader. */
		public uint32 num_readonly_storage_textures; /**< The number of readonly storage textures defined in the shader. */
		public uint32 num_readonly_storage_buffers; /**< The number of readonly storage buffers defined in the shader. */
		public uint32 num_readwrite_storage_textures; /**< The number of read-write storage textures defined in the shader. */
		public uint32 num_readwrite_storage_buffers; /**< The number of read-write storage buffers defined in the shader. */
		public uint32 num_uniform_buffers; /**< The number of uniform buffers defined in the shader. */
		public uint32 threadcount_x; /**< The number of threads in the X dimension. This should match the value in the shader. */
		public uint32 threadcount_y; /**< The number of threads in the Y dimension. This should match the value in the shader. */
		public uint32 threadcount_z; /**< The number of threads in the Z dimension. This should match the value in the shader. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	[CRepr]
	public struct SDL_GPUGraphicsPipeline;

	[CRepr]
	public struct SDL_GPUGraphicsPipelineCreateInfo
	{
		public SDL_GPUShader* vertex_shader; /**< The vertex shader used by the graphics pipeline. */
		public SDL_GPUShader* fragment_shader; /**< The fragment shader used by the graphics pipeline. */
		public SDL_GPUVertexInputState vertex_input_state; /**< The vertex layout of the graphics pipeline. */
		public SDL_GPUPrimitiveType primitive_type; /**< The primitive topology of the graphics pipeline. */
		public SDL_GPURasterizerState rasterizer_state; /**< The rasterizer state of the graphics pipeline. */
		public SDL_GPUMultisampleState multisample_state; /**< The multisample state of the graphics pipeline. */
		public SDL_GPUDepthStencilState depth_stencil_state; /**< The depth-stencil state of the graphics pipeline. */
		public SDL_GPUGraphicsPipelineTargetInfo target_info; /**< Formats and blend modes for the render targets of the graphics pipeline. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	[CRepr]
	public struct SDL_GPUVertexInputState
	{
		public SDL_GPUVertexBufferDescription* vertex_buffer_descriptions; /**< A pointer to an array of vertex buffer descriptions. */
		public uint32 num_vertex_buffers; /**< The number of vertex buffer descriptions in the above array. */
		public SDL_GPUVertexAttribute* vertex_attributes; /**< A pointer to an array of vertex attribute descriptions. */
		public uint32 num_vertex_attributes; /**< The number of vertex attribute descriptions in the above array. */
	}

	[CRepr]
	public struct SDL_GPUVertexBufferDescription
	{
		public uint32 slot; /**< The binding slot of the vertex buffer. */
		public uint32 pitch; /**< The byte pitch between consecutive elements of the vertex buffer. */
		public SDL_GPUVertexInputRate input_rate; /**< Whether attribute addressing is a function of the vertex index or instance index. */
		public uint32 instance_step_rate; /**< Reserved for future use.Must be set to 0. */
	}

	public enum SDL_GPUVertexInputRate : c_int
	{
		SDL_GPU_VERTEXINPUTRATE_VERTEX, /**< Attribute addressing is a function of the vertex index. */
		SDL_GPU_VERTEXINPUTRATE_INSTANCE /**< Attribute addressing is a function of the instance index. */
	}

	[CRepr]
	public struct SDL_GPUVertexAttribute
	{
		public uint32 location; /**< The shader input location index. */
		public uint32 buffer_slot; /**< The binding slot of the associated vertex buffer. */
		public SDL_GPUVertexElementFormat format; /**< The size and type of the attribute data. */
		public uint32 offset; /**< The byte offset of this attribute relative to the start of the vertex element. */
	}

	public enum SDL_GPUVertexElementFormat : c_int
	{
		SDL_GPU_VERTEXELEMENTFORMAT_INVALID,

		/* 32-bit Signed Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_INT,
		SDL_GPU_VERTEXELEMENTFORMAT_INT2,
		SDL_GPU_VERTEXELEMENTFORMAT_INT3,
		SDL_GPU_VERTEXELEMENTFORMAT_INT4,

		/* 32-bit Unsigned Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_UINT,
		SDL_GPU_VERTEXELEMENTFORMAT_UINT2,
		SDL_GPU_VERTEXELEMENTFORMAT_UINT3,
		SDL_GPU_VERTEXELEMENTFORMAT_UINT4,

		/* 32-bit Floats */
		SDL_GPU_VERTEXELEMENTFORMAT_FLOAT,
		SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2,
		SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3,
		SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4,

		/* 8-bit Signed Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_BYTE2,
		SDL_GPU_VERTEXELEMENTFORMAT_BYTE4,

		/* 8-bit Unsigned Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2,
		SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4,

		/* 8-bit Signed Normalized */
		SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM,
		SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM,

		/* 8-bit Unsigned Normalized */
		SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM,
		SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM,

		/* 16-bit Signed Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_SHORT2,
		SDL_GPU_VERTEXELEMENTFORMAT_SHORT4,

		/* 16-bit Unsigned Integers */
		SDL_GPU_VERTEXELEMENTFORMAT_USHORT2,
		SDL_GPU_VERTEXELEMENTFORMAT_USHORT4,

		/* 16-bit Signed Normalized */
		SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM,
		SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM,

		/* 16-bit Unsigned Normalized */
		SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM,
		SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM,

		/* 16-bit Floats */
		SDL_GPU_VERTEXELEMENTFORMAT_HALF2,
		SDL_GPU_VERTEXELEMENTFORMAT_HALF4
	}

	public enum SDL_GPUPrimitiveType : c_int
	{
		SDL_GPU_PRIMITIVETYPE_TRIANGLELIST, /**< A series of separate triangles. */
		SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP, /**< A series of connected triangles. */
		SDL_GPU_PRIMITIVETYPE_LINELIST, /**< A series of separate lines. */
		SDL_GPU_PRIMITIVETYPE_LINESTRIP, /**< A series of connected lines. */
		SDL_GPU_PRIMITIVETYPE_POINTLIST /**< A series of separate points. */
	}

	[CRepr]
	public struct SDL_GPURasterizerState
	{
		public SDL_GPUFillMode fill_mode; /**< Whether polygons will be filled in or drawn as lines. */
		public SDL_GPUCullMode cull_mode; /**< The facing direction in which triangles will be culled. */
		public SDL_GPUFrontFace front_face; /**< The vertex winding that will cause a triangle to be determined as front-facing. */
		public float depth_bias_constant_factor; /**< A scalar factor controlling the depth value added to each fragment. */
		public float depth_bias_clamp; /**< The maximum depth bias of a fragment. */
		public float depth_bias_slope_factor; /**< A scalar factor applied to a fragment's slope in depth calculations. */
		public c_bool enable_depth_bias; /**< true to bias fragment depth values. */
		public c_bool enable_depth_clip; /**< true to enable depth clip, false to enable depth clamp. */
		public uint8 padding1;
		public uint8 padding2;
	}

	public enum SDL_GPUFillMode : c_int
	{
		SDL_GPU_FILLMODE_FILL, /**< Polygons will be rendered via rasterization. */
		SDL_GPU_FILLMODE_LINE /**< Polygon edges will be drawn as line segments. */
	}

	public enum SDL_GPUCullMode : c_int
	{
		SDL_GPU_CULLMODE_NONE, /**< No triangles are culled. */
		SDL_GPU_CULLMODE_FRONT, /**< Front-facing triangles are culled. */
		SDL_GPU_CULLMODE_BACK /**< Back-facing triangles are culled. */
	}

	public enum SDL_GPUFrontFace : c_int
	{
		SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE, /**< A triangle with counter-clockwise vertex winding will be considered front-facing. */
		SDL_GPU_FRONTFACE_CLOCKWISE /**< A triangle with clockwise vertex winding will be considered front-facing. */
	}

	public enum SDL_GPUCubeMapFace : c_int
	{
		SDL_GPU_CUBEMAPFACE_POSITIVEX,
		SDL_GPU_CUBEMAPFACE_NEGATIVEX,
		SDL_GPU_CUBEMAPFACE_POSITIVEY,
		SDL_GPU_CUBEMAPFACE_NEGATIVEY,
		SDL_GPU_CUBEMAPFACE_POSITIVEZ,
		SDL_GPU_CUBEMAPFACE_NEGATIVEZ
	}

	[CRepr]
	public struct SDL_GPUMultisampleState
	{
		public SDL_GPUSampleCount sample_count; /**< The number of samples to be used in rasterization. */
		public uint32 sample_mask; /**< Reserved for future use. Must be set to 0. */
		public c_bool enable_mask; /**< Reserved for future use. Must be set to false.*/
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	public enum SDL_GPUSampleCount : c_int
	{
		SDL_GPU_SAMPLECOUNT_1, /**< No multisampling. */
		SDL_GPU_SAMPLECOUNT_2, /**< MSAA 2x */
		SDL_GPU_SAMPLECOUNT_4, /**< MSAA 4x */
		SDL_GPU_SAMPLECOUNT_8 /**< MSAA 8x */
	}

	[CRepr]
	public struct SDL_GPUDepthStencilState
	{
		public SDL_GPUCompareOp compare_op; /**< The comparison operator used for depth testing. */
		public SDL_GPUStencilOpState back_stencil_state; /**< The stencil op state for back-facing triangles. */
		public SDL_GPUStencilOpState front_stencil_state; /**< The stencil op state for front-facing triangles. */
		public uint8 compare_mask; /**< Selects the bits of the stencil values participating in the stencil test. */
		public uint8 write_mask; /**< Selects the bits of the stencil values updated by the stencil test. */
		public c_bool enable_depth_test; /**< true enables the depth test. */
		public c_bool enable_depth_write; /**< true enables depth writes. Depth writes are always disabled when enable_depth_test is false. */
		public c_bool enable_stencil_test; /**< true enables the stencil test. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	public enum SDL_GPUCompareOp : c_int
	{
		SDL_GPU_COMPAREOP_INVALID,
		SDL_GPU_COMPAREOP_NEVER, /**< The comparison always evaluates false. */
		SDL_GPU_COMPAREOP_LESS, /**< The comparison evaluates reference < test. */
		SDL_GPU_COMPAREOP_EQUAL, /**< The comparison evaluates reference == test. */
		SDL_GPU_COMPAREOP_LESS_OR_EQUAL, /**< The comparison evaluates reference <= test. */
		SDL_GPU_COMPAREOP_GREATER, /**< The comparison evaluates reference > test. */
		SDL_GPU_COMPAREOP_NOT_EQUAL, /**< The comparison evaluates reference != test. */
		SDL_GPU_COMPAREOP_GREATER_OR_EQUAL, /**< The comparison evalutes reference >= test. */
		SDL_GPU_COMPAREOP_ALWAYS /**< The comparison always evaluates true. */
	}

	[CRepr]
	public struct SDL_GPUStencilOpState
	{
		public SDL_GPUStencilOp fail_op; /**< The action performed on samples that fail the stencil test. */
		public SDL_GPUStencilOp pass_op; /**< The action performed on samples that pass the depth and stencil tests. */
		public SDL_GPUStencilOp depth_fail_op; /**< The action performed on samples that pass the stencil test and fail the depth test. */
		public SDL_GPUCompareOp compare_op; /**< The comparison operator used in the stencil test. */
	}

	public enum SDL_GPUStencilOp : c_int
	{
		SDL_GPU_STENCILOP_INVALID,
		SDL_GPU_STENCILOP_KEEP, /**< Keeps the current value. */
		SDL_GPU_STENCILOP_ZERO, /**< Sets the value to 0. */
		SDL_GPU_STENCILOP_REPLACE, /**< Sets the value to reference. */
		SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP, /**< Increments the current value and clamps to the maximum value. */
		SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP, /**< Decrements the current value and clamps to 0. */
		SDL_GPU_STENCILOP_INVERT, /**< Bitwise-inverts the current value. */
		SDL_GPU_STENCILOP_INCREMENT_AND_WRAP, /**< Increments the current value and wraps back to 0. */
		SDL_GPU_STENCILOP_DECREMENT_AND_WRAP /**< Decrements the current value and wraps to the maximum value. */
	}

	[CRepr]
	public struct SDL_GPUGraphicsPipelineTargetInfo
	{
		public SDL_GPUColorTargetDescription* color_target_descriptions; /**< A pointer to an array of color target descriptions. */
		public uint32 num_color_targets; /**< The number of color target descriptions in the above array. */
		public SDL_GPUTextureFormat depth_stencil_format; /**< The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false. */
		public c_bool has_depth_stencil_target; /**< true specifies that the pipeline uses a depth-stencil target. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_GPUColorTargetDescription
	{
		public SDL_GPUTextureFormat format; /**< The pixel format of the texture to be used as a color target. */
		public SDL_GPUColorTargetBlendState blend_state; /**< The blend state to be used for the color target. */
	}

	public enum SDL_GPUTextureFormat : c_int
	{
		SDL_GPU_TEXTUREFORMAT_INVALID,

		/* Unsigned Normalized Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_A8_UNORM,
		SDL_GPU_TEXTUREFORMAT_R8_UNORM,
		SDL_GPU_TEXTUREFORMAT_R8G8_UNORM,
		SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM,
		SDL_GPU_TEXTUREFORMAT_R16_UNORM,
		SDL_GPU_TEXTUREFORMAT_R16G16_UNORM,
		SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM,
		SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM,
		SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM,
		SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM,
		SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM,
		SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM,
		/* Compressed Unsigned Normalized Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM,
		SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM,
		SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM,
		SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM,
		SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM,
		SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM,
		/* Compressed Signed Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT,
		/* Compressed Unsigned Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT,
		/* Signed Normalized Float Color Formats  */
		SDL_GPU_TEXTUREFORMAT_R8_SNORM,
		SDL_GPU_TEXTUREFORMAT_R8G8_SNORM,
		SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM,
		SDL_GPU_TEXTUREFORMAT_R16_SNORM,
		SDL_GPU_TEXTUREFORMAT_R16G16_SNORM,
		SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM,
		/* Signed Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_R16_FLOAT,
		SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT,
		SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT,
		SDL_GPU_TEXTUREFORMAT_R32_FLOAT,
		SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT,
		SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT,
		/* Unsigned Float Color Formats */
		SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT,
		/* Unsigned Integer Color Formats */
		SDL_GPU_TEXTUREFORMAT_R8_UINT,
		SDL_GPU_TEXTUREFORMAT_R8G8_UINT,
		SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT,
		SDL_GPU_TEXTUREFORMAT_R16_UINT,
		SDL_GPU_TEXTUREFORMAT_R16G16_UINT,
		SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT,
		SDL_GPU_TEXTUREFORMAT_R32_UINT,
		SDL_GPU_TEXTUREFORMAT_R32G32_UINT,
		SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT,
		/* Signed Integer Color Formats */
		SDL_GPU_TEXTUREFORMAT_R8_INT,
		SDL_GPU_TEXTUREFORMAT_R8G8_INT,
		SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT,
		SDL_GPU_TEXTUREFORMAT_R16_INT,
		SDL_GPU_TEXTUREFORMAT_R16G16_INT,
		SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT,
		SDL_GPU_TEXTUREFORMAT_R32_INT,
		SDL_GPU_TEXTUREFORMAT_R32G32_INT,
		SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT,
		/* SRGB Unsigned Normalized Color Formats */
		SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB,
		/* Compressed SRGB Unsigned Normalized Color Formats */
		SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB,
		/* Depth Formats */
		SDL_GPU_TEXTUREFORMAT_D16_UNORM,
		SDL_GPU_TEXTUREFORMAT_D24_UNORM,
		SDL_GPU_TEXTUREFORMAT_D32_FLOAT,
		SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT,
		SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT,
		/* Compressed ASTC Normalized Float Color Formats*/
		SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM,
		/* Compressed SRGB ASTC Normalized Float Color Formats*/
		SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB,
		/* Compressed ASTC Signed Float Color Formats*/
		SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT,
		SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT
	}

	[CRepr]
	public struct SDL_GPUColorTargetBlendState
	{
		public SDL_GPUBlendFactor src_color_blendfactor; /**< The value to be multiplied by the source RGB value. */
		public SDL_GPUBlendFactor dst_color_blendfactor; /**< The value to be multiplied by the destination RGB value. */
		public SDL_GPUBlendOp color_blend_op; /**< The blend operation for the RGB components. */
		public SDL_GPUBlendFactor src_alpha_blendfactor; /**< The value to be multiplied by the source alpha. */
		public SDL_GPUBlendFactor dst_alpha_blendfactor; /**< The value to be multiplied by the destination alpha. */
		public SDL_GPUBlendOp alpha_blend_op; /**< The blend operation for the alpha component. */
		public SDL_GPUColorComponentFlags color_write_mask; /**< A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false. */
		public c_bool enable_blend; /**< Whether blending is enabled for the color target. */
		public c_bool enable_color_write_mask; /**< Whether the color write mask is enabled. */
		public uint8 padding1;
		public uint8 padding2;
	}

	public enum SDL_GPUBlendFactor : c_int
	{
		SDL_GPU_BLENDFACTOR_INVALID,
		SDL_GPU_BLENDFACTOR_ZERO, /**< 0 */
		SDL_GPU_BLENDFACTOR_ONE, /**< 1 */
		SDL_GPU_BLENDFACTOR_SRC_COLOR, /**< source color */
		SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR, /**< 1 - source color */
		SDL_GPU_BLENDFACTOR_DST_COLOR, /**< destination color */
		SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR, /**< 1 - destination color */
		SDL_GPU_BLENDFACTOR_SRC_ALPHA, /**< source alpha */
		SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA, /**< 1 - source alpha */
		SDL_GPU_BLENDFACTOR_DST_ALPHA, /**< destination alpha */
		SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA, /**< 1 - destination alpha */
		SDL_GPU_BLENDFACTOR_CONSTANT_COLOR, /**< blend constant */
		SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR, /**< 1 - blend constant */
		SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE /**< min(source alpha, 1 - destination alpha) */
	}

	public enum SDL_GPUBlendOp : c_int
	{
		SDL_GPU_BLENDOP_INVALID,
		SDL_GPU_BLENDOP_ADD, /**< (source * source_factor) + (destination * destination_factor) */
		SDL_GPU_BLENDOP_SUBTRACT, /**< (source * source_factor) - (destination * destination_factor) */
		SDL_GPU_BLENDOP_REVERSE_SUBTRACT, /**< (destination * destination_factor) - (source * source_factor) */
		SDL_GPU_BLENDOP_MIN, /**< min(source, destination) */
		SDL_GPU_BLENDOP_MAX /**< max(source, destination) */
	}

	public enum SDL_GPUColorComponentFlags : uint8
	{
		SDL_GPU_COLORCOMPONENT_R = (1u << 0), /**< the red component */
		SDL_GPU_COLORCOMPONENT_G = (1u << 1), /**< the green component */
		SDL_GPU_COLORCOMPONENT_B = (1u << 2), /**< the blue component */
		SDL_GPU_COLORCOMPONENT_A = (1u << 3) /**< the alpha component */
	}

	[CRepr]
	public struct SDL_GPUSampler;

	[CRepr]
	public struct SDL_GPUSamplerCreateInfo
	{
		public SDL_GPUFilter min_filter; /**< The minification filter to apply to lookups. */
		public SDL_GPUFilter mag_filter; /**< The magnification filter to apply to lookups. */
		public SDL_GPUSamplerMipmapMode mipmap_mode; /**< The mipmap filter to apply to lookups. */
		public SDL_GPUSamplerAddressMode address_mode_u; /**< The addressing mode for U coordinates outside [0, 1). */
		public SDL_GPUSamplerAddressMode address_mode_v; /**< The addressing mode for V coordinates outside [0, 1). */
		public SDL_GPUSamplerAddressMode address_mode_w; /**< The addressing mode for W coordinates outside [0, 1). */
		public float mip_lod_bias; /**< The bias to be added to mipmap LOD calculation. */
		public float max_anisotropy; /**< The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored. */
		public SDL_GPUCompareOp compare_op; /**< The comparison operator to apply to fetched data before filtering. */
		public float min_lod; /**< Clamps the minimum of the computed LOD value. */
		public float max_lod; /**< Clamps the maximum of the computed LOD value. */
		public c_bool enable_anisotropy; /**< true to enable anisotropic filtering. */
		public c_bool enable_compare; /**< true to enable comparison against a reference value during lookups. */
		public uint8 padding1;
		public uint8 padding2;

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	public enum SDL_GPUFilter : c_int
	{
		SDL_GPU_FILTER_NEAREST, /**< Poc_intfiltering. */
		SDL_GPU_FILTER_LINEAR /**< Linear filtering. */
	}

	public enum SDL_GPUSamplerMipmapMode : c_int
	{
		SDL_GPU_SAMPLERMIPMAPMODE_NEAREST, /**< Poc_intfiltering. */
		SDL_GPU_SAMPLERMIPMAPMODE_LINEAR /**< Linear filtering. */
	}

	public enum SDL_GPUSamplerAddressMode : c_int
	{
		SDL_GPU_SAMPLERADDRESSMODE_REPEAT, /**< Specifies that the coordinates will wrap around. */
		SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT, /**< Specifies that the coordinates will wrap around mirrored. */
		SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE /**< Specifies that the coordinates will clamp to the 0-1 range. */
	}

	[CRepr]
	public struct SDL_GPUShader;

	[CRepr]
	public struct SDL_GPUShaderCreateInfo
	{
		public c_size code_size; /**< The size in bytes of the code pointed to. */
		public uint8* code; /**< A pointer to shader code. */
		public c_char* entrypoint; /**< A pointer to a null-terminated UTF-8 string specifying the entry poc_intfunction name for the shader. */
		public SDL_GPUShaderFormat format; /**< The format of the shader code. */
		public SDL_GPUShaderStage stage; /**< The stage the shader program corresponds to. */
		public uint32 num_samplers; /**< The number of samplers defined in the shader. */
		public uint32 num_storage_textures; /**< The number of storage textures defined in the shader. */
		public uint32 num_storage_buffers; /**< The number of storage buffers defined in the shader. */
		public uint32 num_uniform_buffers; /**< The number of uniform buffers defined in the shader. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	public enum SDL_GPUShaderStage : c_int
	{
		SDL_GPU_SHADERSTAGE_VERTEX,
		SDL_GPU_SHADERSTAGE_FRAGMENT
	}

	[CRepr]
	public struct SDL_GPUTexture;

	[CRepr]
	public struct SDL_GPUTextureCreateInfo
	{
		public SDL_GPUTextureType type; /**< The base dimensionality of the texture. */
		public SDL_GPUTextureFormat format; /**< The pixel format of the texture. */
		public SDL_GPUTextureUsageFlags usage; /**< How the texture is intended to be used by the client. */
		public uint32 width; /**< The width of the texture. */
		public uint32 height; /**< The height of the texture. */
		public uint32 layer_count_or_depth; /**< The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures. */
		public uint32 num_levels; /**< The number of mip levels in the texture. */
		public SDL_GPUSampleCount sample_count; /**< The number of samples per texel. Only applies if the texture is used as a render target. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	public enum SDL_GPUTextureType : c_int
	{
		SDL_GPU_TEXTURETYPE_2D, /**< The texture is a 2-dimensional image. */
		SDL_GPU_TEXTURETYPE_2D_ARRAY, /**< The texture is a 2-dimensional array image. */
		SDL_GPU_TEXTURETYPE_3D, /**< The texture is a 3-dimensional image. */
		SDL_GPU_TEXTURETYPE_CUBE, /**< The texture is a cube image. */
		SDL_GPU_TEXTURETYPE_CUBE_ARRAY /**< The texture is a cube array image. */
	}

	public enum SDL_GPUTextureUsageFlags : uint32
	{
		SDL_GPU_TEXTUREUSAGE_SAMPLER                                 = (1u << 0), /**< Texture supports sampling. */
		SDL_GPU_TEXTUREUSAGE_COLOR_TARGET                            = (1u << 1), /**< Texture is a color render target. */
		SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET                    = (1u << 2), /**< Texture is a depth stencil target. */
		SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ                   = (1u << 3), /**< Texture supports storage reads in graphics stages. */
		SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ                    = (1u << 4), /**< Texture supports storage reads in the compute stage. */
		SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE                   = (1u << 5), /**< Texture supports storage writes in the compute stage. */
		SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE = (1u << 6), /**< Texture supports reads and writes in the same compute shader. This is NOT equivalent to READ | WRITE. */
	}

	[CRepr]
	public struct SDL_GPUBuffer;

	[CRepr]
	public struct SDL_GPUBufferCreateInfo
	{
		public SDL_GPUBufferUsageFlags usage; /**< How the buffer is intended to be used by the client. */
		public uint32 size; /**< The size in bytes of the buffer. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	public enum SDL_GPUBufferUsageFlags : uint32
	{
		SDL_GPU_BUFFERUSAGE_VERTEX                                  = (1u << 0), /**< Buffer is a vertex buffer. */
		SDL_GPU_BUFFERUSAGE_INDEX                                   = (1u << 1), /**< Buffer is an index buffer. */
		SDL_GPU_BUFFERUSAGE_INDIRECT                                = (1u << 2), /**< Buffer is an indirect buffer. */
		SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ                   = (1u << 3), /**< Buffer supports storage reads in graphics stages. */
		SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ                    = (1u << 4), /**< Buffer supports storage reads in the compute stage. */
		SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE                   = (1u << 5), /**< Buffer supports storage writes in the compute stage. */
	}

	[CRepr]
	public struct SDL_GPUTransferBuffer;

	[CRepr]
	public struct SDL_GPUTransferBufferCreateInfo
	{
		public SDL_GPUTransferBufferUsage usage; /**< How the transfer buffer is intended to be used by the client. */
		public uint32 size; /**< The size in bytes of the transfer buffer. */

		public SDL_PropertiesID props; /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
	}

	public enum SDL_GPUTransferBufferUsage : c_int
	{
		SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
		SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD
	}

	[CRepr]
	public struct SDL_GPUCommandBuffer;

	[CRepr]
	public struct SDL_GPURenderPass;

	[CRepr]
	public struct SDL_GPUColorTargetInfo
	{
		public SDL_GPUTexture* texture; /**< The texture that will be used as a color target by a render pass. */
		public uint32 mip_level; /**< The mip level to use as a color target. */
		public uint32 layer_or_depth_plane; /**< The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
		public SDL_FColor clear_color; /**< The color to clear the color target to at the start of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
		public SDL_GPULoadOp load_op; /**< What is done with the contents of the color target at the beginning of the render pass. */
		public SDL_GPUStoreOp store_op; /**< What is done with the results of the render pass. */
		public SDL_GPUTexture* resolve_texture; /**< The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used. */
		public uint32 resolve_mip_level; /**< The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
		public uint32 resolve_layer; /**< The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
		public c_bool cycle; /**< true cycles the texture if the texture is bound and load_op is not LOAD */
		public c_bool cycle_resolve_texture; /**< true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used. */
		public uint8 padding1;
		public uint8 padding2;
	}

	public enum SDL_GPULoadOp : c_int
	{
		SDL_GPU_LOADOP_LOAD, /**< The previous contents of the texture will be preserved. */
		SDL_GPU_LOADOP_CLEAR, /**< The contents of the texture will be cleared to a color. */
		SDL_GPU_LOADOP_DONT_CARE /**< The previous contents of the texture need not be preserved. The contents will be undefined. */
	}

	public enum SDL_GPUStoreOp : c_int
	{
		SDL_GPU_STOREOP_STORE, /**< The contents generated during the render pass will be written to memory. */
		SDL_GPU_STOREOP_DONT_CARE, /**< The contents generated during the render pass are not needed and may be discarded. The contents will be undefined. */
		SDL_GPU_STOREOP_RESOLVE, /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture may then be discarded and will be undefined. */
		SDL_GPU_STOREOP_RESOLVE_AND_STORE /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture will be written to memory. */
	}

	[CRepr]
	public struct SDL_GPUViewport
	{
		public float x; /**< The left offset of the viewport. */
		public float y; /**< The top offset of the viewport. */
		public float w; /**< The width of the viewport. */
		public float h; /**< The height of the viewport. */
		public float min_depth; /**< The minimum depth of the viewport. */
		public float max_depth; /**< The maximum depth of the viewport. */
	}

	[CRepr]
	public struct SDL_GPUBufferBinding
	{
		public SDL_GPUBuffer* buffer; /**< The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_VERTEX for SDL_BindGPUVertexBuffers, or SDL_GPU_BUFFERUSAGE_INDEX for SDL_BindGPUIndexBuffers. */
		public uint32 offset; /**< The starting byte of the data to bind in the buffer. */
	}

	public enum SDL_GPUIndexElementSize : c_int
	{
		SDL_GPU_INDEXELEMENTSIZE_16BIT, /**< The index elements are 16-bit. */
		SDL_GPU_INDEXELEMENTSIZE_32BIT /**< The index elements are 32-bit. */
	}

	[CRepr]
	public struct SDL_GPUTextureSamplerBinding
	{
		public SDL_GPUTexture* texture; /**< The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER. */
		public SDL_GPUSampler* sampler; /**< The sampler to bind. */
	}

	[CRepr]
	public struct SDL_GPUComputePass;

	[CRepr]
	public struct SDL_GPUStorageTextureReadWriteBinding
	{
		public SDL_GPUTexture* texture; /**< The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE or SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE. */
		public uint32 mip_level; /**< The mip level index to bind. */
		public uint32 layer; /**< The layer index to bind. */
		public c_bool cycle; /**< true cycles the texture if it is already bound. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_GPUCopyPass;

	[CRepr]
	public struct SDL_GPUTextureTransferInfo
	{
		public SDL_GPUTransferBuffer* transfer_buffer; /**< The transfer buffer used in the transfer operation. */
		public uint32 offset; /**< The starting byte of the image data in the transfer buffer. */
		public uint32 pixels_per_row; /**< The number of pixels from one row to the next. */
		public uint32 rows_per_layer; /**< The number of rows from one layer/depth-slice to the next. */
	}

	[CRepr]
	public struct SDL_GPUTextureRegion
	{
		public SDL_GPUTexture* texture; /**< The texture used in the copy operation. */
		public uint32 mip_level; /**< The mip level index to transfer. */
		public uint32 layer; /**< The layer index to transfer. */
		public uint32 x; /**< The left offset of the region. */
		public uint32 y; /**< The top offset of the region. */
		public uint32 z; /**< The front offset of the region. */
		public uint32 w; /**< The width of the region. */
		public uint32 h; /**< The height of the region. */
		public uint32 d; /**< The depth of the region. */
	}

	[CRepr]
	public struct SDL_GPUTransferBufferLocation
	{
		public SDL_GPUTransferBuffer* transfer_buffer; /**< The transfer buffer used in the transfer operation. */
		public uint32 offset; /**< The starting byte of the buffer data in the transfer buffer. */
	}

	[CRepr]
	public struct SDL_GPUBufferRegion
	{
		public SDL_GPUBuffer* buffer; /**< The buffer. */
		public uint32 offset; /**< The starting byte within the buffer. */
		public uint32 size; /**< The size in bytes of the region. */
	}

	[CRepr]
	public struct SDL_GPUTextureLocation
	{
		public SDL_GPUTexture* texture; /**< The texture used in the copy operation. */
		public uint32 mip_level; /**< The mip level index of the location. */
		public uint32 layer; /**< The layer index of the location. */
		public uint32 x; /**< The left offset of the location. */
		public uint32 y; /**< The top offset of the location. */
		public uint32 z; /**< The front offset of the location. */
	}

	[CRepr]
	public struct SDL_GPUBufferLocation
	{
		public SDL_GPUBuffer* buffer; /**< The buffer. */
		public uint32 offset; /**< The starting byte within the buffer. */
	}

	[CRepr]
	public struct SDL_GPUBlitInfo
	{
		public SDL_GPUBlitRegion source; /**< The source region for the blit. */
		public SDL_GPUBlitRegion destination; /**< The destination region for the blit. */
		public SDL_GPULoadOp load_op; /**< What is done with the contents of the destination before the blit. */
		public SDL_FColor clear_color; /**< The color to clear the destination region to before the blit. Ignored if load_op is not SDL_GPU_LOADOP_CLEAR. */
		public SDL_FlipMode flip_mode; /**< The flip mode for the source region. */
		public SDL_GPUFilter filter; /**< The filter mode used when blitting. */
		public c_bool cycle; /**< true cycles the destination texture if it is already bound. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_GPUBlitRegion
	{
		public SDL_GPUTexture* texture; /**< The texture. */
		public uint32 mip_level; /**< The mip level index of the region. */
		public uint32 layer_or_depth_plane; /**< The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
		public uint32 x; /**< The left offset of the region. */
		public uint32 y; /**< The top offset of the region.  */
		public uint32 w; /**< The width of the region. */
		public uint32 h; /**< The height of the region. */
	}

	public enum SDL_GPUSwapchainComposition : c_int
	{
		SDL_GPU_SWAPCHAINCOMPOSITION_SDR,
		SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR,
		SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR,
		SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2048
	}

	public enum SDL_GPUPresentMode : c_int
	{
		SDL_GPU_PRESENTMODE_VSYNC,
		SDL_GPU_PRESENTMODE_IMMEDIATE,
		SDL_GPU_PRESENTMODE_MAILBOX
	}

	[CRepr]
	public struct SDL_GPUFence;

	[CRepr]
	public struct SDL_GPUDepthStencilTargetInfo
	{
		public SDL_GPUTexture* texture; /**< The texture that will be used as the depth stencil target by the render pass. */
		public float clear_depth; /**< The value to clear the depth component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
		public SDL_GPULoadOp load_op; /**< What is done with the depth contents at the beginning of the render pass. */
		public SDL_GPUStoreOp store_op; /**< What is done with the depth results of the render pass. */
		public SDL_GPULoadOp stencil_load_op; /**< What is done with the stencil contents at the beginning of the render pass. */
		public SDL_GPUStoreOp stencil_store_op; /**< What is done with the stencil results of the render pass. */
		public c_bool cycle; /**< true cycles the texture if the texture is bound and any load ops are not LOAD */
		public uint8 clear_stencil; /**< The value to clear the stencil component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
		public int8 padding1;
		public uint8 padding2;
	}

	[CRepr]
	public struct SDL_GPUStorageBufferReadWriteBinding
	{
		public SDL_GPUBuffer* buffer; /**< The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE. */
		public c_bool cycle; /**< true cycles the buffer if it is already bound. */
		public uint8 padding1;
		public uint8 padding2;
		public uint8 padding3;
	}

	[CRepr]
	public struct SDL_GPUIndirectDrawCommand
	{
		public uint32 num_vertices; /**< The number of vertices to draw. */
		public uint32 num_instances; /**< The number of instances to draw. */
		public uint32 first_vertex; /**< The index of the first vertex to draw. */
		public uint32 first_instance; /**< The ID of the first instance to draw. */
	}

	[CRepr]
	public struct SDL_GPUIndexedIndirectDrawCommand
	{
		public uint32 num_indices; /**< The number of indices to draw per instance. */
		public uint32 num_instances; /**< The number of instances to draw. */
		public uint32 first_index; /**< The base index within the index buffer. */
		public c_int vertex_offset; /**< The value added to the vertex index before indexing into the vertex buffer. */
		public uint32 first_instance; /**< The ID of the first instance to draw. */
	}

	[CRepr]
	public struct SDL_GPUIndirectDispatchCommand
	{
		public uint32 groupcount_x; /**< The number of local workgroups to dispatch in the X dimension. */
		public uint32 groupcount_y; /**< The number of local workgroups to dispatch in the Y dimension. */
		public uint32 groupcount_z; /**< The number of local workgroups to dispatch in the Z dimension. */
	}

	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN          = "SDL.gpu.device.create.debugmode";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN     = "SDL.gpu.device.create.preferlowpower";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING                = "SDL.gpu.device.create.name";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN    = "SDL.gpu.device.create.shaders.private";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN      = "SDL.gpu.device.create.shaders.spirv";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN       = "SDL.gpu.device.create.shaders.dxbc";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN       = "SDL.gpu.device.create.shaders.dxil";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN        = "SDL.gpu.device.create.shaders.msl";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN   = "SDL.gpu.device.create.shaders.metallib";
	public const c_char* SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING = "SDL.gpu.device.create.d3d12.semantic";

	public const c_char* SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING = "SDL.gpu.computepipeline.create.name";

	public const c_char* SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING = "SDL.gpu.graphicspipeline.create.name";

	public const c_char* SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING = "SDL.gpu.sampler.create.name";

	public const c_char* SDL_PROP_GPU_SHADER_CREATE_NAME_STRING = "SDL.gpu.shader.create.name";

	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT       = "SDL.gpu.texture.create.d3d12.clear.r";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT       = "SDL.gpu.texture.create.d3d12.clear.g";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT       = "SDL.gpu.texture.create.d3d12.clear.b";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT       = "SDL.gpu.texture.create.d3d12.clear.a";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT   = "SDL.gpu.texture.create.d3d12.clear.depth";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_NUMBER = "SDL.gpu.texture.create.d3d12.clear.stencil";
	public const c_char* SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING               = "SDL.gpu.texture.create.name";

	public const c_char* SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING = "SDL.gpu.buffer.create.name";

	public const c_char* SDL_PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING = "SDL.gpu.transferbuffer.create.name";


	[CLink] public static extern c_bool SDL_CancelGPUCommandBuffer(SDL_GPUCommandBuffer* command_buffer);

	[CLink] public static extern c_bool SDL_GPUSupportsShaderFormats(SDL_GPUShaderFormat format_flags, c_char* name);

	[CLink] public static extern c_bool SDL_GPUSupportsProperties(SDL_PropertiesID props);

	[CLink] public static extern SDL_GPUDevice* SDL_CreateGPUDevice(SDL_GPUShaderFormat format_flags, c_bool debug_mode, c_char* name);

	[CLink] public static extern SDL_GPUDevice* SDL_CreateGPUDeviceWithProperties(SDL_PropertiesID props);

	[CLink] public static extern void SDL_DestroyGPUDevice(SDL_GPUDevice* device);

	[CLink] public static extern c_int SDL_GetNumGPUDrivers();

	[CLink] public static extern c_char* SDL_GetGPUDriver(c_int index);

	[CLink] public static extern c_char* SDL_GetGPUDeviceDriver(SDL_GPUDevice* device);

	[CLink] public static extern SDL_GPUShaderFormat SDL_GetGPUShaderFormats(SDL_GPUDevice* device);

	[CLink] public static extern SDL_GPUComputePipeline* SDL_CreateGPUComputePipeline(SDL_GPUDevice* device, SDL_GPUComputePipelineCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUGraphicsPipeline* SDL_CreateGPUGraphicsPipeline(SDL_GPUDevice* device, SDL_GPUGraphicsPipelineCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUSampler* SDL_CreateGPUSampler(SDL_GPUDevice* device, SDL_GPUSamplerCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUShader* SDL_CreateGPUShader(SDL_GPUDevice* device, SDL_GPUShaderCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUTexture* SDL_CreateGPUTexture(SDL_GPUDevice* device, SDL_GPUTextureCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUBuffer* SDL_CreateGPUBuffer(SDL_GPUDevice* device, SDL_GPUBufferCreateInfo* createinfo);

	[CLink] public static extern SDL_GPUTransferBuffer* SDL_CreateGPUTransferBuffer(SDL_GPUDevice* device, SDL_GPUTransferBufferCreateInfo* createinfo);

	[CLink] public static extern void SDL_SetGPUBufferName(SDL_GPUDevice* device, SDL_GPUBuffer* buffer, c_char* text);

	[CLink] public static extern void SDL_SetGPUTextureName(SDL_GPUDevice* device, SDL_GPUTexture* texture, c_char* text);

	[CLink] public static extern void SDL_InsertGPUDebugLabel(SDL_GPUCommandBuffer* command_buffer, c_char* text);

	[CLink] public static extern void SDL_PushGPUDebugGroup(SDL_GPUCommandBuffer* command_buffer, c_char* name);

	[CLink] public static extern void SDL_PopGPUDebugGroup(SDL_GPUCommandBuffer* command_buffer);

	[CLink] public static extern void SDL_ReleaseGPUTexture(SDL_GPUDevice* device, SDL_GPUTexture* texture);

	[CLink] public static extern void SDL_ReleaseGPUSampler(SDL_GPUDevice* device, SDL_GPUSampler* sampler);

	[CLink] public static extern void SDL_ReleaseGPUBuffer(SDL_GPUDevice* device, SDL_GPUBuffer* buffer);

	[CLink] public static extern void SDL_ReleaseGPUTransferBuffer(SDL_GPUDevice* device, SDL_GPUTransferBuffer* transfer_buffer);

	[CLink] public static extern void SDL_ReleaseGPUComputePipeline(SDL_GPUDevice* device, SDL_GPUComputePipeline* compute_pipeline);

	[CLink] public static extern void SDL_ReleaseGPUShader(SDL_GPUDevice* device, SDL_GPUShader* shader);

	[CLink] public static extern void SDL_ReleaseGPUGraphicsPipeline(SDL_GPUDevice* device, SDL_GPUGraphicsPipeline* graphics_pipeline);

	[CLink] public static extern SDL_GPUCommandBuffer* SDL_AcquireGPUCommandBuffer(SDL_GPUDevice* device);

	[CLink] public static extern void SDL_PushGPUVertexUniformData(SDL_GPUCommandBuffer* command_buffer, uint32 slot_index, void* data, uint32 length);

	[CLink] public static extern void SDL_PushGPUFragmentUniformData(SDL_GPUCommandBuffer* command_buffer, uint32 slot_index, void* data, uint32 length);

	[CLink] public static extern void SDL_PushGPUComputeUniformData(SDL_GPUCommandBuffer* command_buffer, uint32 slot_index, void* data, uint32 length);

	[CLink] public static extern SDL_GPURenderPass* SDL_BeginGPURenderPass(SDL_GPUCommandBuffer* command_buffer, SDL_GPUColorTargetInfo* color_target_infos, uint32 num_color_targets, SDL_GPUDepthStencilTargetInfo* depth_stencil_target_info);

	[CLink] public static extern void SDL_BindGPUGraphicsPipeline(SDL_GPURenderPass* render_pass, SDL_GPUGraphicsPipeline* graphics_pipeline);

	[CLink] public static extern void SDL_SetGPUViewport(SDL_GPURenderPass* render_pass, SDL_GPUViewport* viewport);

	[CLink] public static extern void SDL_SetGPUScissor(SDL_GPURenderPass* render_pass, SDL_Rect* scissor);

	[CLink] public static extern void SDL_SetGPUBlendConstants(SDL_GPURenderPass* render_pass, SDL_FColor blend_constants);

	[CLink] public static extern void SDL_SetGPUStencilReference(SDL_GPURenderPass* render_pass, uint8 reference);

	[CLink] public static extern void SDL_BindGPUVertexBuffers(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUBufferBinding* bindings, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUIndexBuffer(SDL_GPURenderPass* render_pass, SDL_GPUBufferBinding* binding, SDL_GPUIndexElementSize index_element_size);

	[CLink] public static extern void SDL_BindGPUVertexSamplers(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUTextureSamplerBinding* texture_sampler_bindings, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUVertexStorageTextures(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUTexture** storage_textures, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUVertexStorageBuffers(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUBuffer** storage_buffers, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUFragmentSamplers(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUTextureSamplerBinding* texture_sampler_bindings, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUFragmentStorageTextures(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUTexture** storage_textures, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUFragmentStorageBuffers(SDL_GPURenderPass* render_pass, uint32 first_slot, SDL_GPUBuffer** storage_buffers, uint32 num_bindings);

	[CLink] public static extern void SDL_DrawGPUIndexedPrimitives(SDL_GPURenderPass* render_pass, uint32 num_indices, uint32 num_instances, uint32 first_index, c_int vertex_offset, uint32 first_instance);

	[CLink] public static extern void SDL_DrawGPUPrimitives(SDL_GPURenderPass* render_pass, uint32 num_vertices, uint32 num_instances, uint32 first_vertex, uint32 first_instance);

	[CLink] public static extern void SDL_DrawGPUPrimitivesIndirect(SDL_GPURenderPass* render_pass, SDL_GPUBuffer* buffer, uint32 offset, uint32 draw_count);

	[CLink] public static extern void SDL_DrawGPUIndexedPrimitivesIndirect(SDL_GPURenderPass* render_pass, SDL_GPUBuffer* buffer, uint32 offset, uint32 draw_count);

	[CLink] public static extern void SDL_EndGPURenderPass(SDL_GPURenderPass* render_pass);

	[CLink] public static extern SDL_GPUComputePass* SDL_BeginGPUComputePass(SDL_GPUCommandBuffer* command_buffer, SDL_GPUStorageTextureReadWriteBinding* storage_texture_bindings, uint32 num_storage_texture_bindings, SDL_GPUStorageBufferReadWriteBinding* storage_buffer_bindings, uint32 num_storage_buffer_bindings);

	[CLink] public static extern void SDL_BindGPUComputePipeline(SDL_GPUComputePass* compute_pass, SDL_GPUComputePipeline* compute_pipeline);

	[CLink] public static extern void SDL_BindGPUComputeSamplers(SDL_GPUComputePass* compute_pass, uint32 first_slot, SDL_GPUTextureSamplerBinding* texture_sampler_bindings, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUComputeStorageTextures(SDL_GPUComputePass* compute_pass, uint32 first_slot, SDL_GPUTexture** storage_textures, uint32 num_bindings);

	[CLink] public static extern void SDL_BindGPUComputeStorageBuffers(SDL_GPUComputePass* compute_pass, uint32 first_slot, SDL_GPUBuffer** storage_buffers, uint32 num_bindings);

	[CLink] public static extern void SDL_DispatchGPUCompute(SDL_GPUComputePass* compute_pass, uint32 groupcount_x, uint32 groupcount_y, uint32 groupcount_z);

	[CLink] public static extern void SDL_DispatchGPUComputeIndirect(SDL_GPUComputePass* compute_pass, SDL_GPUBuffer* buffer, uint32 offset);

	[CLink] public static extern void SDL_EndGPUComputePass(SDL_GPUComputePass* compute_pass);

	[CLink] public static extern void* SDL_MapGPUTransferBuffer(SDL_GPUDevice* device, SDL_GPUTransferBuffer* transfer_buffer, c_bool cycle);

	[CLink] public static extern void SDL_UnmapGPUTransferBuffer(SDL_GPUDevice* device, SDL_GPUTransferBuffer* transfer_buffer);

	[CLink] public static extern SDL_GPUCopyPass* SDL_BeginGPUCopyPass(SDL_GPUCommandBuffer* command_buffer);

	[CLink] public static extern void SDL_UploadToGPUTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureTransferInfo* source, SDL_GPUTextureRegion* destination, c_bool cycle);

	[CLink] public static extern void SDL_UploadToGPUBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUTransferBufferLocation* source, SDL_GPUBufferRegion* destination, c_bool cycle);

	[CLink] public static extern void SDL_CopyGPUTextureToTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureLocation* source, SDL_GPUTextureLocation* destination, uint32 w, uint32 h, uint32 d, c_bool cycle);

	[CLink] public static extern void SDL_CopyGPUBufferToBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUBufferLocation* source, SDL_GPUBufferLocation* destination, uint32 size, c_bool cycle);

	[CLink] public static extern void SDL_DownloadFromGPUTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureRegion* source, SDL_GPUTextureTransferInfo* destination);

	[CLink] public static extern void SDL_DownloadFromGPUBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUBufferRegion* source, SDL_GPUTransferBufferLocation* destination);

	[CLink] public static extern void SDL_EndGPUCopyPass(SDL_GPUCopyPass* copy_pass);

	[CLink] public static extern void SDL_GenerateMipmapsForGPUTexture(SDL_GPUCommandBuffer* command_buffer, SDL_GPUTexture* texture);

	[CLink] public static extern void SDL_BlitGPUTexture(SDL_GPUCommandBuffer* command_buffer, SDL_GPUBlitInfo* info);

	[CLink] public static extern c_bool SDL_WindowSupportsGPUSwapchainComposition(SDL_GPUDevice* device, SDL_Window* window, SDL_GPUSwapchainComposition swapchain_composition);

	[CLink] public static extern c_bool SDL_WindowSupportsGPUPresentMode(SDL_GPUDevice* device, SDL_Window* window, SDL_GPUPresentMode present_mode);

	[CLink] public static extern c_bool SDL_ClaimWindowForGPUDevice(SDL_GPUDevice* device, SDL_Window* window);

	[CLink] public static extern void SDL_ReleaseWindowFromGPUDevice(SDL_GPUDevice* device, SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetGPUSwapchainParameters(SDL_GPUDevice* device, SDL_Window* window, SDL_GPUSwapchainComposition swapchain_composition, SDL_GPUPresentMode present_mode);

	[CLink] public static extern SDL_GPUTextureFormat SDL_GetGPUSwapchainTextureFormat(SDL_GPUDevice* device, SDL_Window* window);

	[CLink] public static extern c_bool SDL_AcquireGPUSwapchainTexture(SDL_GPUCommandBuffer* command_buffer, SDL_Window* window, SDL_GPUTexture** swapchain_texture, uint32* swapchain_texture_width, uint32* swapchain_texture_height);

	[CLink] public static extern c_bool SDL_SubmitGPUCommandBuffer(SDL_GPUCommandBuffer* command_buffer);

	[CLink] public static extern SDL_GPUFence* SDL_SubmitGPUCommandBufferAndAcquireFence(SDL_GPUCommandBuffer* command_buffer);

	[CLink] public static extern c_bool SDL_WaitForGPUIdle(SDL_GPUDevice* device);

	[CLink] public static extern c_bool SDL_WaitForGPUFences(SDL_GPUDevice* device, c_bool wait_all, SDL_GPUFence** fences, uint32 num_fences);

	[CLink] public static extern c_bool SDL_QueryGPUFence(SDL_GPUDevice* device, SDL_GPUFence* fence);

	[CLink] public static extern void SDL_ReleaseGPUFence(SDL_GPUDevice* device, SDL_GPUFence* fence);

	[CLink] public static extern uint32 SDL_GPUTextureFormatTexelBlockSize(SDL_GPUTextureFormat format);

	[CLink] public static extern c_bool SDL_GPUTextureSupportsFormat(SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUTextureType type, SDL_GPUTextureUsageFlags usage);

	[CLink] public static extern c_bool SDL_GPUTextureSupportsSampleCount(SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUSampleCount sample_count);

	[CLink] public static extern uint32 SDL_CalculateGPUTextureFormatSize(SDL_GPUTextureFormat format, uint32 width, uint32 height, uint32 depth_or_layer_count);

	[CLink] public static extern void SDL_GDKSuspendGPU(SDL_GPUDevice* device);

	[CLink] public static extern void SDL_GDKResumeGPU(SDL_GPUDevice* device);

	[CLink] public static extern c_bool SDL_SetGPUAllowedFramesInFlight(SDL_GPUDevice* device, uint32 allowed_frames_in_flight);

	[CLink] public static extern c_bool SDL_WaitForGPUSwapchain(SDL_GPUDevice* device, SDL_Window* window);

	[CLink] public static extern c_bool SDL_WaitAndAcquireGPUSwapchainTexture(SDL_GPUCommandBuffer* command_buffer, SDL_Window* window, SDL_GPUTexture** swapchain_texture, uint32* swapchain_texture_width, uint32* swapchain_texture_height);

	//SDL_guid.h

	[CRepr]
	public struct SDL_GUID
	{
		public uint8[16] data;
	}

	[CLink] public static extern void SDL_GUIDToString(SDL_GUID guid, c_char* pszGUID, c_int cbGUID);

	[CLink] public static extern SDL_GUID SDL_StringToGUID(c_char* pchGUID);

	//SDL_haptic.h

	public typealias SDL_HapticID = uint32;

	[CRepr]
	public struct SDL_Haptic;


	public const uint64 SDL_HAPTIC_CONSTANT     = (1u << 0);

	public const uint64 SDL_HAPTIC_SINE         = (1u << 1);

	public const uint64 SDL_HAPTIC_SQUARE       = (1u << 2);

	public const uint64 SDL_HAPTIC_TRIANGLE     = (1u << 3);

	public const uint64 SDL_HAPTIC_SAWTOOTHUP   = (1u << 4);

	public const uint64 SDL_HAPTIC_SAWTOOTHDOWN = (1u << 5);

	public const uint64 SDL_HAPTIC_RAMP         = (1u << 6);

	public const uint64 SDL_HAPTIC_SPRING       = (1u << 7);

	public const uint64 SDL_HAPTIC_DAMPER       = (1u << 8);

	public const uint64 SDL_HAPTIC_INERTIA      = (1u << 9);

	public const uint64 SDL_HAPTIC_FRICTION     = (1u << 10);

	public const uint64 SDL_HAPTIC_LEFTRIGHT    = (1u << 11);

	public const uint64 SDL_HAPTIC_RESERVED1    = (1u << 12);

	public const uint64 SDL_HAPTIC_RESERVED2    = (1u << 13);

	public const uint64 SDL_HAPTIC_RESERVED3    = (1u << 14);

	public const uint64 SDL_HAPTIC_CUSTOM       = (1u << 15);

	public const uint64 SDL_HAPTIC_GAIN       = (1u << 16);

	public const uint64 SDL_HAPTIC_AUTOCENTER = (1u << 17);

	public const uint64 SDL_HAPTIC_STATUS     = (1u << 18);

	public const uint64 SDL_HAPTIC_PAUSE      = (1u << 19);

	public const uint64 SDL_HAPTIC_POLAR      = 0;

	public const uint64 SDL_HAPTIC_CARTESIAN  = 1;

	public const uint64 SDL_HAPTIC_SPHERICAL  = 2;

	public const uint64 SDL_HAPTIC_STEERING_AXIS = 3;

	public const uint64 SDL_HAPTIC_INFINITY   = 4294967295U;

	[CRepr, Union]
	public struct SDL_HapticEffect
	{
		/* Common for all force feedback effects */
		public uint16 type; /**< Effect type. */
		SDL_HapticConstant constant; /**< Constant effect. */
		SDL_HapticPeriodic periodic; /**< Periodic effect. */
		SDL_HapticCondition condition; /**< Condition effect. */
		SDL_HapticRamp ramp; /**< Ramp effect. */
		SDL_HapticLeftRight leftright; /**< Left/Right effect. */
		SDL_HapticCustom custom; /**< Custom effect. */
	}

	[CRepr]
	public struct SDL_HapticConstant
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_CONSTANT */
		public SDL_HapticDirection direction; /**< Direction of the effect. */

		/* Replay */
		public uint32 length; /**< Duration of the effect. */
		public uint16 delay; /**< Delay before starting the effect. */

		/* Trigger */
		public uint16 button; /**< Button that triggers the effect. */
		public uint16 interval; /**< How soon it can be triggered again after button. */

		/* Constant */
		public int16 level; /**< Strength of the constant effect. */

		/* Envelope */
		public uint16 attack_length; /**< Duration of the attack. */
		public uint16 attack_level; /**< Level at the start of the attack. */
		public uint16 fade_length; /**< Duration of the fade. */
		public uint16 fade_level; /**< Level at the end of the fade. */
	}

	[CRepr]
	public struct SDL_HapticDirection
	{
		public uint8 type; /**< The type of encoding. */
		public c_int[3] dir; /**< The encoded direction. */
	}

	[CRepr]
	public struct SDL_HapticPeriodic
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_SINE, SDL_HAPTIC_SQUARE
								 SDL_HAPTIC_TRIANGLE, SDL_HAPTIC_SAWTOOTHUP or
								 SDL_HAPTIC_SAWTOOTHDOWN */
		public SDL_HapticDirection direction; /**< Direction of the effect. */

		/* Replay */
		public uint32 length; /**< Duration of the effect. */
		public uint16 delay; /**< Delay before starting the effect. */

		/* Trigger */
		public uint16 button; /**< Button that triggers the effect. */
		public uint16 interval; /**< How soon it can be triggered again after button. */

		/* Periodic */
		public uint16 period; /**< Period of the wave. */
		public int16 magnitude; /**< Peak value; if negative, equivalent to 180 degrees extra phase shift. */
		public int16 offset; /**< Mean value of the wave. */
		public uint16 phase; /**< Positive phase shift given by hundredth of a degree. */

		/* Envelope */
		public uint16 attack_length; /**< Duration of the attack. */
		public uint16 attack_level; /**< Level at the start of the attack. */
		public uint16 fade_length; /**< Duration of the fade. */
		public uint16 fade_level; /**< Level at the end of the fade. */
	}

	[CRepr]
	public struct SDL_HapticCondition
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_SPRING, SDL_HAPTIC_DAMPER,
									 SDL_HAPTIC_INERTIA or SDL_HAPTIC_FRICTION */
		public SDL_HapticDirection direction; /**< Direction of the effect - Not used ATM. */

		/* Replay */
		public uint32 length; /**< Duration of the effect. */
		public uint16 delay; /**< Delay before starting the effect. */

		/* Trigger */
		public uint16 button; /**< Button that triggers the effect. */
		public uint16 interval; /**< How soon it can be triggered again after button. */

		/* Condition */
		public uint16[3] right_sat; /**< Level when joystick is to the positive side; max 0xFFFF. */
		public uint16[3] left_sat; /**< Level when joystick is to the negative side; max 0xFFFF. */
		public int16[3] right_coeff; /**< How fast to increase the force towards the positive side. */
		public int16[3] left_coeff; /**< How fast to increase the force towards the negative side. */
		public uint16[3] deadband; /**< Size of the dead zone; max 0xFFFF: whole axis-range when 0-centered. */
		public int16[3] center; /**< Position of the dead zone. */
	}

	[CRepr]
	public struct SDL_HapticRamp
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_RAMP */
		public SDL_HapticDirection direction; /**< Direction of the effect. */

		/* Replay */
		public uint32 length; /**< Duration of the effect. */
		public uint16 delay; /**< Delay before starting the effect. */

		/* Trigger */
		public uint16 button; /**< Button that triggers the effect. */
		public uint16 interval; /**< How soon it can be triggered again after button. */

		/* Ramp */
		public int16 start; /**< Beginning strength level. */
		public int16 end; /**< Ending strength level. */

		/* Envelope */
		public uint16 attack_length; /**< Duration of the attack. */
		public uint16 attack_level; /**< Level at the start of the attack. */
		public uint16 fade_length; /**< Duration of the fade. */
		public uint16 fade_level; /**< Level at the end of the fade. */
	}

	[CRepr]
	public struct SDL_HapticLeftRight
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_LEFTRIGHT */

		/* Replay */
		public uint32 length; /**< Duration of the effect in milliseconds. */

		/* Rumble */
		public uint16 large_magnitude; /**< Control of the large controller motor. */
		public uint16 small_magnitude; /**< Control of the small controller motor. */
	}

	[CRepr]
	public struct SDL_HapticCustom
	{
		/* Header */
		public uint16 type; /**< SDL_HAPTIC_CUSTOM */
		public SDL_HapticDirection direction; /**< Direction of the effect. */

		/* Replay */
		public uint32 length; /**< Duration of the effect. */
		public uint16 delay; /**< Delay before starting the effect. */

		/* Trigger */
		public uint16 button; /**< Button that triggers the effect. */
		public uint16 interval; /**< How soon it can be triggered again after button. */

		/* Custom */
		public uint8 channels; /**< Axes to use, minimum of one. */
		public uint16 period; /**< Sample periods. */
		public uint16 samples; /**< Amount of samples. */
		public uint16* data; /**< Should contain channels*samples items. */

		/* Envelope */
		public uint16 attack_length; /**< Duration of the attack. */
		public uint16 attack_level; /**< Level at the start of the attack. */
		public uint16 fade_length; /**< Duration of the fade. */
		public uint16 fade_level; /**< Level at the end of the fade. */
	}

	[CLink] public static extern SDL_HapticID* SDL_GetHaptics(c_int* count);

	[CLink] public static extern c_char* SDL_GetHapticNameForID(SDL_HapticID instance_id);

	[CLink] public static extern SDL_Haptic* SDL_OpenHaptic(SDL_HapticID instance_id);

	[CLink] public static extern SDL_Haptic* SDL_GetHapticFromID(SDL_HapticID instance_id);

	[CLink] public static extern SDL_HapticID SDL_GetHapticID(SDL_Haptic* haptic);

	[CLink] public static extern c_char* SDL_GetHapticName(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_IsMouseHaptic();

	[CLink] public static extern SDL_Haptic* SDL_OpenHapticFromMouse();

	[CLink] public static extern c_bool SDL_IsJoystickHaptic(SDL_Joystick* joystick);

	[CLink] public static extern SDL_Haptic* SDL_OpenHapticFromJoystick(SDL_Joystick* joystick);

	[CLink] public static extern void SDL_CloseHaptic(SDL_Haptic* haptic);

	[CLink] public static extern c_int SDL_GetMaxHapticEffects(SDL_Haptic* haptic);

	[CLink] public static extern c_int SDL_GetMaxHapticEffectsPlaying(SDL_Haptic* haptic);

	[CLink] public static extern uint32 SDL_GetHapticFeatures(SDL_Haptic* haptic);

	[CLink] public static extern c_int SDL_GetNumHapticAxes(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_HapticEffectSupported(SDL_Haptic* haptic, SDL_HapticEffect* effect);

	[CLink] public static extern c_int SDL_CreateHapticEffect(SDL_Haptic* haptic, SDL_HapticEffect* effect);

	[CLink] public static extern c_bool SDL_UpdateHapticEffect(SDL_Haptic* haptic, c_int effect, SDL_HapticEffect* data);

	[CLink] public static extern c_bool SDL_RunHapticEffect(SDL_Haptic* haptic, c_int effect, uint32 iterations);

	[CLink] public static extern c_bool SDL_StopHapticEffect(SDL_Haptic* haptic, c_int effect);

	[CLink] public static extern void SDL_DestroyHapticEffect(SDL_Haptic* haptic, c_int effect);

	[CLink] public static extern c_bool SDL_GetHapticEffectStatus(SDL_Haptic* haptic, c_int effect);

	[CLink] public static extern c_bool SDL_SetHapticGain(SDL_Haptic* haptic, c_int gain);

	[CLink] public static extern c_bool SDL_SetHapticAutocenter(SDL_Haptic* haptic, c_int autocenter);

	[CLink] public static extern c_bool SDL_PauseHaptic(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_ResumeHaptic(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_StopHapticEffects(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_HapticRumbleSupported(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_InitHapticRumble(SDL_Haptic* haptic);

	[CLink] public static extern c_bool SDL_PlayHapticRumble(SDL_Haptic* haptic, float strength, uint32 length);

	[CLink] public static extern c_bool SDL_StopHapticRumble(SDL_Haptic* haptic);

	//SDL_hidapi.h

	[CRepr]
	public struct SDL_hid_device_info
	{
		/** Platform-specific device path */
		public c_char* path;
		/** Device Vendor ID */
		public c_ushort vendor_id;
		/** Device Product ID */
		public c_ushort product_id;
		/** Serial Number */
		public c_wchar* serial_number;
		/** Device Release Number in binary-coded decimal,
			also known as Device Version Number */
		public c_ushort release_number;
		/** Manufacturer String */
		public c_wchar* manufacturer_string;
		/** Product string */
		public c_wchar* product_string;
		/** Usage Page for this Device/Interface
			(Windows/Mac/hidraw only) */
		public c_ushort usage_page;
		/** Usage for this Device/Interface
			(Windows/Mac/hidraw only) */
		public c_ushort usage;
		/** The USB interface which this logical device
			represents.

			Valid only if the device is a USB HID device.
			Set to -1 in all other cases.
		*/
		public c_int interface_number;

		/** Additional information about the USB interface.
			Valid on libusb and Android implementations. */
		public c_int interface_class;
		public c_int interface_subclass;
		public c_int interface_protocol;

		/** Underlying bus type */
		public SDL_hid_bus_type bus_type;

		/** Pointer to the next device */
		public SDL_hid_device_info* next;
	}

	public enum SDL_hid_bus_type : c_int
	{
		/** Unknown bus type */
		SDL_HID_API_BUS_UNKNOWN = 0x00,

		/** USB bus
		   Specifications:
		   https://usb.org/hid */
		SDL_HID_API_BUS_USB = 0x01,

		/** Bluetooth or Bluetooth LE bus
		   Specifications:
		   https://www.bluetooth.com/specifications/specs/human-interface-device-profile-1-1-1/
		   https://www.bluetooth.com/specifications/specs/hid-service-1-0/
		   https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-1-0/ */
		SDL_HID_API_BUS_BLUETOOTH = 0x02,

		/** I2C bus
		   Specifications:
		   https://docs.microsoft.com/previous-versions/windows/hardware/design/dn642101(v=vs.85) */
		SDL_HID_API_BUS_I2C = 0x03,

		/** SPI bus
		   Specifications:
		   https://www.microsoft.com/download/details.aspx?id=103325 */
		SDL_HID_API_BUS_SPI = 0x04

	}

	[CRepr]
	public struct SDL_hid_device;

	[CLink] public static extern c_int SDL_hid_init();

	[CLink] public static extern c_int SDL_hid_exit();

	[CLink] public static extern uint32 SDL_hid_device_change_count();

	[CLink] public static extern SDL_hid_device_info* SDL_hid_enumerate(c_ushort vendor_id, c_ushort product_id);

	[CLink] public static extern void SDL_hid_free_enumeration(SDL_hid_device_info* devs);

	[CLink] public static extern SDL_hid_device* SDL_hid_open(c_ushort vendor_id, c_ushort product_id, c_wchar* serial_number);

	[CLink] public static extern SDL_hid_device* SDL_hid_open_path(c_char* path);

	[CLink] public static extern c_int SDL_hid_write(SDL_hid_device* dev, c_uchar* data, c_size length);

	[CLink] public static extern c_int SDL_hid_read_timeout(SDL_hid_device* dev, c_uchar* data, c_size length, c_int milliseconds);

	[CLink] public static extern c_int SDL_hid_read(SDL_hid_device* dev, c_uchar* data, c_size length);

	[CLink] public static extern c_int SDL_hid_set_nonblocking(SDL_hid_device* dev, c_int nonblock);

	[CLink] public static extern c_int SDL_hid_send_feature_report(SDL_hid_device* dev, c_uchar* data, c_size length);

	[CLink] public static extern c_int SDL_hid_get_feature_report(SDL_hid_device* dev, c_uchar* data, c_size length);

	[CLink] public static extern c_int SDL_hid_get_input_report(SDL_hid_device* dev, c_uchar* data, c_size length);

	[CLink] public static extern c_int SDL_hid_close(SDL_hid_device* dev);

	[CLink] public static extern c_int SDL_hid_get_manufacturer_string(SDL_hid_device* dev, c_wchar* string, c_size maxlen);

	[CLink] public static extern c_int SDL_hid_get_product_string(SDL_hid_device* dev, c_wchar* string, c_size maxlen);

	[CLink] public static extern c_int SDL_hid_get_serial_number_string(SDL_hid_device* dev, c_wchar* string, c_size maxlen);

	[CLink] public static extern c_int SDL_hid_get_indexed_string(SDL_hid_device* dev, c_int string_index, c_wchar* string, c_size maxlen);

	[CLink] public static extern SDL_hid_device_info* SDL_hid_get_device_info(SDL_hid_device* dev);

	[CLink] public static extern c_int SDL_hid_get_report_descriptor(SDL_hid_device* dev, c_uchar* buf, c_size buf_size);

	[CLink] public static extern void SDL_hid_ble_scan(c_bool active);

	//SDL_hints.h

	public const c_char* SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED = "SDL_ALLOW_ALT_TAB_WHILE_GRABBED";
	public const c_char* SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY = "SDL_ANDROID_ALLOW_RECREATE_ACTIVITY";
	public const c_char* SDL_HINT_ANDROID_BLOCK_ON_PAUSE = "SDL_ANDROID_BLOCK_ON_PAUSE";
	public const c_char* SDL_HINT_ANDROID_LOW_LATENCY_AUDIO = "SDL_ANDROID_LOW_LATENCY_AUDIO";
	public const c_char* SDL_HINT_ANDROID_TRAP_BACK_BUTTON = "SDL_ANDROID_TRAP_BACK_BUTTON";
	public const c_char* SDL_HINT_APP_ID = "SDL_APP_ID";
	public const c_char* SDL_HINT_APP_NAME = "SDL_APP_NAME";
	public const c_char* SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS = "SDL_APPLE_TV_CONTROLLER_UI_EVENTS";
	public const c_char* SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION = "SDL_APPLE_TV_REMOTE_ALLOW_ROTATION";
	public const c_char* SDL_HINT_AUDIO_ALSA_DEFAULT_DEVICE = "SDL_AUDIO_ALSA_DEFAULT_DEVICE";
	public const c_char* SDL_HINT_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE = "SDL_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE";
	public const c_char* SDL_HINT_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE = "SDL_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE";
	public const c_char* SDL_HINT_AUDIO_CATEGORY = "SDL_AUDIO_CATEGORY";
	public const c_char* SDL_HINT_AUDIO_CHANNELS = "SDL_AUDIO_CHANNELS";
	public const c_char* SDL_HINT_AUDIO_DEVICE_APP_ICON_NAME = "SDL_AUDIO_DEVICE_APP_ICON_NAME";
	public const c_char* SDL_HINT_AUDIO_DEVICE_SAMPLE_FRAMES = "SDL_AUDIO_DEVICE_SAMPLE_FRAMES";
	public const c_char* SDL_HINT_AUDIO_DEVICE_STREAM_NAME = "SDL_AUDIO_DEVICE_STREAM_NAME";
	public const c_char* SDL_HINT_AUDIO_DEVICE_STREAM_ROLE = "SDL_AUDIO_DEVICE_STREAM_ROLE";
	public const c_char* SDL_HINT_AUDIO_DISK_INPUT_FILE = "SDL_AUDIO_DISK_INPUT_FILE";
	public const c_char* SDL_HINT_AUDIO_DISK_OUTPUT_FILE = "SDL_AUDIO_DISK_OUTPUT_FILE";
	public const c_char* SDL_HINT_AUDIO_DISK_TIMESCALE = "SDL_AUDIO_DISK_TIMESCALE";
	public const c_char* SDL_HINT_AUDIO_DRIVER = "SDL_AUDIO_DRIVER";
	public const c_char* SDL_HINT_AUDIO_DUMMY_TIMESCALE = "SDL_AUDIO_DUMMY_TIMESCALE";
	public const c_char* SDL_HINT_AUDIO_FORMAT = "SDL_AUDIO_FORMAT";
	public const c_char* SDL_HINT_AUDIO_FREQUENCY = "SDL_AUDIO_FREQUENCY";
	public const c_char* SDL_HINT_AUDIO_INCLUDE_MONITORS = "SDL_AUDIO_INCLUDE_MONITORS";
	public const c_char* SDL_HINT_AUTO_UPDATE_JOYSTICKS = "SDL_AUTO_UPDATE_JOYSTICKS";
	public const c_char* SDL_HINT_AUTO_UPDATE_SENSORS = "SDL_AUTO_UPDATE_SENSORS";
	public const c_char* SDL_HINT_BMP_SAVE_LEGACY_FORMAT = "SDL_BMP_SAVE_LEGACY_FORMAT";
	public const c_char* SDL_HINT_CAMERA_DRIVER = "SDL_CAMERA_DRIVER";
	public const c_char* SDL_HINT_CPU_FEATURE_MASK = "SDL_CPU_FEATURE_MASK";
	public const c_char* SDL_HINT_JOYSTICK_DIRECTINPUT = "SDL_JOYSTICK_DIRECTINPUT";
	public const c_char* SDL_HINT_FILE_DIALOG_DRIVER = "SDL_FILE_DIALOG_DRIVER";
	public const c_char* SDL_HINT_DISPLAY_USABLE_BOUNDS = "SDL_DISPLAY_USABLE_BOUNDS";
	public const c_char* SDL_HINT_EMSCRIPTEN_ASYNCIFY = "SDL_EMSCRIPTEN_ASYNCIFY";
	public const c_char* SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR = "SDL_EMSCRIPTEN_CANVAS_SELECTOR";
	public const c_char* SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT = "SDL_EMSCRIPTEN_KEYBOARD_ELEMENT";
	public const c_char* SDL_HINT_ENABLE_SCREEN_KEYBOARD = "SDL_ENABLE_SCREEN_KEYBOARD";
	public const c_char* SDL_HINT_EVDEV_DEVICES = "SDL_EVDEV_DEVICES";
	public const c_char* SDL_HINT_EVENT_LOGGING = "SDL_EVENT_LOGGING";
	public const c_char* SDL_HINT_FORCE_RAISEWINDOW = "SDL_FORCE_RAISEWINDOW";
	public const c_char* SDL_HINT_FRAMEBUFFER_ACCELERATION = "SDL_FRAMEBUFFER_ACCELERATION";
	public const c_char* SDL_HINT_GAMECONTROLLERCONFIG = "SDL_GAMECONTROLLERCONFIG";
	public const c_char* SDL_HINT_GAMECONTROLLERCONFIG_FILE = "SDL_GAMECONTROLLERCONFIG_FILE";
	public const c_char* SDL_HINT_GAMECONTROLLERTYPE = "SDL_GAMECONTROLLERTYPE";
	public const c_char* SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES = "SDL_GAMECONTROLLER_IGNORE_DEVICES";
	public const c_char* SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT = "SDL_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT";
	public const c_char* SDL_HINT_GAMECONTROLLER_SENSOR_FUSION = "SDL_GAMECONTROLLER_SENSOR_FUSION";
	public const c_char* SDL_HINT_GDK_TEXTINPUT_DEFAULT_TEXT = "SDL_GDK_TEXTINPUT_DEFAULT_TEXT";
	public const c_char* SDL_HINT_GDK_TEXTINPUT_DESCRIPTION = "SDL_GDK_TEXTINPUT_DESCRIPTION";
	public const c_char* SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH = "SDL_GDK_TEXTINPUT_MAX_LENGTH";
	public const c_char* SDL_HINT_GDK_TEXTINPUT_SCOPE = "SDL_GDK_TEXTINPUT_SCOPE";
	public const c_char* SDL_HINT_GDK_TEXTINPUT_TITLE = "SDL_GDK_TEXTINPUT_TITLE";
	public const c_char* SDL_HINT_HIDAPI_LIBUSB = "SDL_HIDAPI_LIBUSB";
	public const c_char* SDL_HINT_HIDAPI_LIBUSB_WHITELIST = "SDL_HIDAPI_LIBUSB_WHITELIST";
	public const c_char* SDL_HINT_HIDAPI_UDEV = "SDL_HIDAPI_UDEV";
	public const c_char* SDL_HINT_GPU_DRIVER = "SDL_GPU_DRIVER";
	public const c_char* SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS = "SDL_HIDAPI_ENUMERATE_ONLY_CONTROLLERS";
	public const c_char* SDL_HINT_HIDAPI_IGNORE_DEVICES = "SDL_HIDAPI_IGNORE_DEVICES";
	public const c_char* SDL_HINT_IME_IMPLEMENTED_UI = "SDL_IME_IMPLEMENTED_UI";
	public const c_char* SDL_HINT_IOS_HIDE_HOME_INDICATOR = "SDL_IOS_HIDE_HOME_INDICATOR";
	public const c_char* SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS = "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS";
	public const c_char* SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES = "SDL_JOYSTICK_ARCADESTICK_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED = "SDL_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_BLACKLIST_DEVICES = "SDL_JOYSTICK_BLACKLIST_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED = "SDL_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_DEVICE = "SDL_JOYSTICK_DEVICE";
	public const c_char* SDL_HINT_JOYSTICK_ENHANCED_REPORTS = "SDL_JOYSTICK_ENHANCED_REPORTS";
	public const c_char* SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES = "SDL_JOYSTICK_FLIGHTSTICK_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED = "SDL_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_GAMEINPUT = "SDL_JOYSTICK_GAMEINPUT";
	public const c_char* SDL_HINT_JOYSTICK_GAMECUBE_DEVICES = "SDL_JOYSTICK_GAMECUBE_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED = "SDL_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI = "SDL_JOYSTICK_HIDAPI";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS = "SDL_JOYSTICK_HIDAPI_COMBINE_JOY_CONS";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE = "SDL_JOYSTICK_HIDAPI_GAMECUBE";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE = "SDL_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS = "SDL_JOYSTICK_HIDAPI_JOY_CONS";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED = "SDL_JOYSTICK_HIDAPI_JOYCON_HOME_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_LUNA = "SDL_JOYSTICK_HIDAPI_LUNA";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC = "SDL_JOYSTICK_HIDAPI_NINTENDO_CLASSIC";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS3 = "SDL_JOYSTICK_HIDAPI_PS3";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER = "SDL_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS4 = "SDL_JOYSTICK_HIDAPI_PS4";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL = "SDL_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS5 = "SDL_JOYSTICK_HIDAPI_PS5";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED = "SDL_JOYSTICK_HIDAPI_PS5_PLAYER_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_SHIELD = "SDL_JOYSTICK_HIDAPI_SHIELD";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_STADIA = "SDL_JOYSTICK_HIDAPI_STADIA";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_STEAM = "SDL_JOYSTICK_HIDAPI_STEAM";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_STEAM_HOME_LED = "SDL_JOYSTICK_HIDAPI_STEAM_HOME_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_STEAMDECK = "SDL_JOYSTICK_HIDAPI_STEAMDECK";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_STEAM_HORI = "SDL_JOYSTICK_HIDAPI_STEAM_HORI";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_SWITCH = "SDL_JOYSTICK_HIDAPI_SWITCH";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED = "SDL_JOYSTICK_HIDAPI_SWITCH_HOME_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED = "SDL_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS = "SDL_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_WII = "SDL_JOYSTICK_HIDAPI_WII";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED = "SDL_JOYSTICK_HIDAPI_WII_PLAYER_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX = "SDL_JOYSTICK_HIDAPI_XBOX";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX_360 = "SDL_JOYSTICK_HIDAPI_XBOX_360";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED = "SDL_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS = "SDL_JOYSTICK_HIDAPI_XBOX_360_WIRELESS";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE = "SDL_JOYSTICK_HIDAPI_XBOX_ONE";
	public const c_char* SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED = "SDL_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED";
	public const c_char* SDL_HINT_JOYSTICK_IOKIT = "SDL_JOYSTICK_IOKIT";
	public const c_char* SDL_HINT_JOYSTICK_LINUX_CLASSIC = "SDL_JOYSTICK_LINUX_CLASSIC";
	public const c_char* SDL_HINT_JOYSTICK_LINUX_DEADZONES = "SDL_JOYSTICK_LINUX_DEADZONES";
	public const c_char* SDL_HINT_JOYSTICK_LINUX_DIGITAL_HATS = "SDL_JOYSTICK_LINUX_DIGITAL_HATS";
	public const c_char* SDL_HINT_JOYSTICK_LINUX_HAT_DEADZONES = "SDL_JOYSTICK_LINUX_HAT_DEADZONES";
	public const c_char* SDL_HINT_JOYSTICK_MFI = "SDL_JOYSTICK_MFI";
	public const c_char* SDL_HINT_JOYSTICK_RAWINPUT = "SDL_JOYSTICK_RAWINPUT";
	public const c_char* SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT = "SDL_JOYSTICK_RAWINPUT_CORRELATE_XINPUT";
	public const c_char* SDL_HINT_JOYSTICK_ROG_CHAKRAM = "SDL_JOYSTICK_ROG_CHAKRAM";
	public const c_char* SDL_HINT_JOYSTICK_THREAD = "SDL_JOYSTICK_THREAD";
	public const c_char* SDL_HINT_JOYSTICK_THROTTLE_DEVICES = "SDL_JOYSTICK_THROTTLE_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_THROTTLE_DEVICES_EXCLUDED = "SDL_JOYSTICK_THROTTLE_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_WGI = "SDL_JOYSTICK_WGI";
	public const c_char* SDL_HINT_JOYSTICK_WHEEL_DEVICES = "SDL_JOYSTICK_WHEEL_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_WHEEL_DEVICES_EXCLUDED = "SDL_JOYSTICK_WHEEL_DEVICES_EXCLUDED";
	public const c_char* SDL_HINT_JOYSTICK_ZERO_CENTERED_DEVICES = "SDL_JOYSTICK_ZERO_CENTERED_DEVICES";
	public const c_char* SDL_HINT_JOYSTICK_HAPTIC_AXES = "SDL_JOYSTICK_HAPTIC_AXES";
	public const c_char* SDL_HINT_KEYCODE_OPTIONS = "SDL_KEYCODE_OPTIONS";
	public const c_char* SDL_HINT_KMSDRM_DEVICE_INDEX = "SDL_KMSDRM_DEVICE_INDEX";
	public const c_char* SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER = "SDL_KMSDRM_REQUIRE_DRM_MASTER";
	public const c_char* SDL_HINT_LOGGING = "SDL_LOGGING";
	public const c_char* SDL_HINT_MAC_BACKGROUND_APP = "SDL_MAC_BACKGROUND_APP";
	public const c_char* SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK = "SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK";
	public const c_char* SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH = "SDL_MAC_OPENGL_ASYNC_DISPATCH";
	public const c_char* SDL_HINT_MAC_OPTION_AS_ALT = "SDL_MAC_OPTION_AS_ALT";
	public const c_char* SDL_HINT_MAC_SCROLL_MOMENTUM = "SDL_MAC_SCROLL_MOMENTUM";
	public const c_char* SDL_HINT_MAIN_CALLBACK_RATE = "SDL_MAIN_CALLBACK_RATE";
	public const c_char* SDL_HINT_MOUSE_AUTO_CAPTURE = "SDL_MOUSE_AUTO_CAPTURE";
	public const c_char* SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS = "SDL_MOUSE_DOUBLE_CLICK_RADIUS";
	public const c_char* SDL_HINT_MOUSE_DOUBLE_CLICK_TIME = "SDL_MOUSE_DOUBLE_CLICK_TIME";
	public const c_char* SDL_HINT_MOUSE_DEFAULT_SYSTEM_CURSOR = "SDL_MOUSE_DEFAULT_SYSTEM_CURSOR";
	public const c_char* SDL_HINT_MOUSE_EMULATE_WARP_WITH_RELATIVE = "SDL_MOUSE_EMULATE_WARP_WITH_RELATIVE";
	public const c_char* SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH = "SDL_MOUSE_FOCUS_CLICKTHROUGH";
	public const c_char* SDL_HINT_MOUSE_NORMAL_SPEED_SCALE = "SDL_MOUSE_NORMAL_SPEED_SCALE";
	public const c_char* SDL_HINT_MOUSE_RELATIVE_MODE_CENTER = "SDL_MOUSE_RELATIVE_MODE_CENTER";
	public const c_char* SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE = "SDL_MOUSE_RELATIVE_SPEED_SCALE";
	public const c_char* SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE = "SDL_MOUSE_RELATIVE_SYSTEM_SCALE";
	public const c_char* SDL_HINT_MOUSE_RELATIVE_WARP_MOTION = "SDL_MOUSE_RELATIVE_WARP_MOTION";
	public const c_char* SDL_HINT_MOUSE_RELATIVE_CURSOR_VISIBLE = "SDL_MOUSE_RELATIVE_CURSOR_VISIBLE";
	public const c_char* SDL_HINT_MOUSE_TOUCH_EVENTS = "SDL_MOUSE_TOUCH_EVENTS";
	public const c_char* SDL_HINT_MUTE_CONSOLE_KEYBOARD = "SDL_MUTE_CONSOLE_KEYBOARD";
	public const c_char* SDL_HINT_NO_SIGNAL_HANDLERS = "SDL_NO_SIGNAL_HANDLERS";
	public const c_char* SDL_HINT_OPENGL_LIBRARY = "SDL_OPENGL_LIBRARY";
	public const c_char* SDL_HINT_EGL_LIBRARY = "SDL_EGL_LIBRARY";
	public const c_char* SDL_HINT_OPENGL_ES_DRIVER = "SDL_OPENGL_ES_DRIVER";
	public const c_char* SDL_HINT_OPENVR_LIBRARY              = "SDL_OPENVR_LIBRARY";
	public const c_char* SDL_HINT_ORIENTATIONS = "SDL_ORIENTATIONS";
	public const c_char* SDL_HINT_POLL_SENTINEL = "SDL_POLL_SENTINEL";
	public const c_char* SDL_HINT_PREFERRED_LOCALES = "SDL_PREFERRED_LOCALES";
	public const c_char* SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE = "SDL_QUIT_ON_LAST_WINDOW_CLOSE";
	public const c_char* SDL_HINT_RENDER_DIRECT3D_THREADSAFE = "SDL_RENDER_DIRECT3D_THREADSAFE";
	public const c_char* SDL_HINT_RENDER_DIRECT3D11_DEBUG = "SDL_RENDER_DIRECT3D11_DEBUG";
	public const c_char* SDL_HINT_RENDER_VULKAN_DEBUG = "SDL_RENDER_VULKAN_DEBUG";
	public const c_char* SDL_HINT_RENDER_GPU_DEBUG = "SDL_RENDER_GPU_DEBUG";
	public const c_char* SDL_HINT_RENDER_GPU_LOW_POWER = "SDL_RENDER_GPU_LOW_POWER";
	public const c_char* SDL_HINT_RENDER_DRIVER = "SDL_RENDER_DRIVER";
	public const c_char* SDL_HINT_RENDER_LINE_METHOD = "SDL_RENDER_LINE_METHOD";
	public const c_char* SDL_HINT_RENDER_METAL_PREFER_LOW_POWER_DEVICE = "SDL_RENDER_METAL_PREFER_LOW_POWER_DEVICE";
	public const c_char* SDL_HINT_RENDER_VSYNC = "SDL_RENDER_VSYNC";
	public const c_char* SDL_HINT_RETURN_KEY_HIDES_IME = "SDL_RETURN_KEY_HIDES_IME";
	public const c_char* SDL_HINT_ROG_GAMEPAD_MICE = "SDL_ROG_GAMEPAD_MICE";
	public const c_char* SDL_HINT_ROG_GAMEPAD_MICE_EXCLUDED = "SDL_ROG_GAMEPAD_MICE_EXCLUDED";
	public const c_char* SDL_HINT_RPI_VIDEO_LAYER = "SDL_RPI_VIDEO_LAYER";
	public const c_char* SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME = "SDL_SCREENSAVER_INHIBIT_ACTIVITY_NAME";
	public const c_char* SDL_HINT_SHUTDOWN_DBUS_ON_QUIT = "SDL_SHUTDOWN_DBUS_ON_QUIT";
	public const c_char* SDL_HINT_STORAGE_TITLE_DRIVER = "SDL_STORAGE_TITLE_DRIVER";
	public const c_char* SDL_HINT_STORAGE_USER_DRIVER = "SDL_STORAGE_USER_DRIVER";
	public const c_char* SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL = "SDL_THREAD_FORCE_REALTIME_TIME_CRITICAL";
	public const c_char* SDL_HINT_THREAD_PRIORITY_POLICY = "SDL_THREAD_PRIORITY_POLICY";
	public const c_char* SDL_HINT_TIMER_RESOLUTION = "SDL_TIMER_RESOLUTION";
	public const c_char* SDL_HINT_TOUCH_MOUSE_EVENTS = "SDL_TOUCH_MOUSE_EVENTS";
	public const c_char* SDL_HINT_TRACKPAD_IS_TOUCH_ONLY = "SDL_TRACKPAD_IS_TOUCH_ONLY";
	public const c_char* SDL_HINT_TV_REMOTE_AS_JOYSTICK = "SDL_TV_REMOTE_AS_JOYSTICK";
	public const c_char* SDL_HINT_VIDEO_ALLOW_SCREENSAVER = "SDL_VIDEO_ALLOW_SCREENSAVER";
	public const c_char* SDL_HINT_VIDEO_DISPLAY_PRIORITY = "SDL_VIDEO_DISPLAY_PRIORITY";
	public const c_char* SDL_HINT_VIDEO_DOUBLE_BUFFER = "SDL_VIDEO_DOUBLE_BUFFER";
	public const c_char* SDL_HINT_VIDEO_DRIVER = "SDL_VIDEO_DRIVER";
	public const c_char* SDL_HINT_VIDEO_DUMMY_SAVE_FRAMES = "SDL_VIDEO_DUMMY_SAVE_FRAMES";
	public const c_char* SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK = "SDL_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK";
	public const c_char* SDL_HINT_VIDEO_FORCE_EGL = "SDL_VIDEO_FORCE_EGL";
	public const c_char* SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES = "SDL_VIDEO_MAC_FULLSCREEN_SPACES";
	public const c_char* SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY = "SDL_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY";
	public const c_char* SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS";
	public const c_char* SDL_HINT_VIDEO_OFFSCREEN_SAVE_FRAMES = "SDL_VIDEO_OFFSCREEN_SAVE_FRAMES";
	public const c_char* SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS = "SDL_VIDEO_SYNC_WINDOW_OPERATIONS";
	public const c_char* SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR = "SDL_VIDEO_WAYLAND_ALLOW_LIBDECOR";
	public const c_char* SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION = "SDL_VIDEO_WAYLAND_MODE_EMULATION";
	public const c_char* SDL_HINT_VIDEO_WAYLAND_MODE_SCALING = "SDL_VIDEO_WAYLAND_MODE_SCALING";
	public const c_char* SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR = "SDL_VIDEO_WAYLAND_PREFER_LIBDECOR";
	public const c_char* SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY = "SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY";
	public const c_char* SDL_HINT_VIDEO_WIN_D3DCOMPILER = "SDL_VIDEO_WIN_D3DCOMPILER";
	public const c_char* SDL_HINT_VIDEO_X11_EXTERNAL_WINDOW_INPUT = "SDL_VIDEO_X11_EXTERNAL_WINDOW_INPUT";
	public const c_char* SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR = "SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR";
	public const c_char* SDL_HINT_VIDEO_X11_NET_WM_PING = "SDL_VIDEO_X11_NET_WM_PING";
	public const c_char* SDL_HINT_VIDEO_X11_NODIRECTCOLOR = "SDL_VIDEO_X11_NODIRECTCOLOR";
	public const c_char* SDL_HINT_VIDEO_X11_SCALING_FACTOR = "SDL_VIDEO_X11_SCALING_FACTOR";
	public const c_char* SDL_HINT_VIDEO_X11_VISUALID = "SDL_VIDEO_X11_VISUALID";
	public const c_char* SDL_HINT_VIDEO_X11_WINDOW_VISUALID = "SDL_VIDEO_X11_WINDOW_VISUALID";
	public const c_char* SDL_HINT_VIDEO_X11_XRANDR = "SDL_VIDEO_X11_XRANDR";
	public const c_char* SDL_HINT_VITA_ENABLE_BACK_TOUCH = "SDL_VITA_ENABLE_BACK_TOUCH";
	public const c_char* SDL_HINT_VITA_ENABLE_FRONT_TOUCH = "SDL_VITA_ENABLE_FRONT_TOUCH";
	public const c_char* SDL_HINT_VITA_MODULE_PATH = "SDL_VITA_MODULE_PATH";
	public const c_char* SDL_HINT_VITA_PVR_INIT = "SDL_VITA_PVR_INIT";
	public const c_char* SDL_HINT_VITA_RESOLUTION = "SDL_VITA_RESOLUTION";
	public const c_char* SDL_HINT_VITA_PVR_OPENGL = "SDL_VITA_PVR_OPENGL";
	public const c_char* SDL_HINT_VITA_TOUCH_MOUSE_DEVICE = "SDL_VITA_TOUCH_MOUSE_DEVICE";
	public const c_char* SDL_HINT_VULKAN_DISPLAY = "SDL_VULKAN_DISPLAY";
	public const c_char* SDL_HINT_VULKAN_LIBRARY = "SDL_VULKAN_LIBRARY";
	public const c_char* SDL_HINT_WAVE_FACT_CHUNK = "SDL_WAVE_FACT_CHUNK";
	public const c_char* SDL_HINT_WAVE_CHUNK_LIMIT = "SDL_WAVE_CHUNK_LIMIT";
	public const c_char* SDL_HINT_WAVE_RIFF_CHUNK_SIZE = "SDL_WAVE_RIFF_CHUNK_SIZE";
	public const c_char* SDL_HINT_WAVE_TRUNCATION = "SDL_WAVE_TRUNCATION";
	public const c_char* SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED = "SDL_WINDOW_ACTIVATE_WHEN_RAISED";
	public const c_char* SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN = "SDL_WINDOW_ACTIVATE_WHEN_SHOWN";
	public const c_char* SDL_HINT_WINDOW_ALLOW_TOPMOST = "SDL_WINDOW_ALLOW_TOPMOST";
	public const c_char* SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN = "SDL_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN";
	public const c_char* SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4 = "SDL_WINDOWS_CLOSE_ON_ALT_F4";
	public const c_char* SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS = "SDL_WINDOWS_ENABLE_MENU_MNEMONICS";
	public const c_char* SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP = "SDL_WINDOWS_ENABLE_MESSAGELOOP";
	public const c_char* SDL_HINT_WINDOWS_GAMEINPUT   = "SDL_WINDOWS_GAMEINPUT";
	public const c_char* SDL_HINT_WINDOWS_RAW_KEYBOARD = "SDL_WINDOWS_RAW_KEYBOARD";
	public const c_char* SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL = "SDL_WINDOWS_FORCE_SEMAPHORE_KERNEL";
	public const c_char* SDL_HINT_WINDOWS_INTRESOURCE_ICON       = "SDL_WINDOWS_INTRESOURCE_ICON";
	public const c_char* SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL = "SDL_WINDOWS_INTRESOURCE_ICON_SMALL";
	public const c_char* SDL_HINT_WINDOWS_USE_D3D9EX = "SDL_WINDOWS_USE_D3D9EX";
	public const c_char* SDL_HINT_WINDOWS_ERASE_BACKGROUND_MODE = "SDL_WINDOWS_ERASE_BACKGROUND_MODE";
	public const c_char* SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT = "SDL_X11_FORCE_OVERRIDE_REDIRECT";
	public const c_char* SDL_HINT_X11_WINDOW_TYPE = "SDL_X11_WINDOW_TYPE";
	public const c_char* SDL_HINT_X11_XCB_LIBRARY = "SDL_X11_XCB_LIBRARY";
	public const c_char* SDL_HINT_XINPUT_ENABLED = "SDL_XINPUT_ENABLED";
	public const c_char* SDL_HINT_ASSERT = "SDL_ASSERT";
	public const c_char* SDL_HINT_PEN_MOUSE_EVENTS = "SDL_PEN_MOUSE_EVENTS";
	public const c_char* SDL_HINT_PEN_TOUCH_EVENTS = "SDL_PEN_TOUCH_EVENTS";


	public enum SDL_HintPriority : c_int
	{
		SDL_HINT_DEFAULT,
		SDL_HINT_NORMAL,
		SDL_HINT_OVERRIDE
	}

	typealias SDL_HintCallback = function void(void* userdata, c_char* name, c_char* oldValue, c_char* newValue);

	[CLink] public static extern c_bool SDL_SetHintWithPriority(c_char* name, c_char* value, SDL_HintPriority priority);

	[CLink] public static extern c_bool SDL_SetHint(c_char* name, c_char* value);

	[CLink] public static extern c_bool SDL_ResetHint(c_char* name);

	[CLink] public static extern void SDL_ResetHints();

	[CLink] public static extern c_char* SDL_GetHint(c_char* name);

	[CLink] public static extern c_bool SDL_GetHintBoolean(c_char* name, c_bool default_value);

	[CLink] public static extern c_bool SDL_AddHintCallback(c_char* name, SDL_HintCallback callback, void* userdata);

	[CLink] public static extern void SDL_RemoveHintCallback(c_char* name, SDL_HintCallback callback, void* userdata);

	//SDL_init.h

	public enum SDL_InitFlags : uint32
	{
		SDL_INIT_AUDIO      = 0x00000010u, /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
		SDL_INIT_VIDEO      = 0x00000020u, /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS` */
		SDL_INIT_JOYSTICK   = 0x00000200u, /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS`, should be initialized on the same thread as SDL_INIT_VIDEO on Windows if you don't set SDL_HINT_JOYSTICK_THREAD */
		SDL_INIT_HAPTIC     = 0x00001000u,
		SDL_INIT_GAMEPAD    = 0x00002000u, /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
		SDL_INIT_EVENTS     = 0x00004000u,
		SDL_INIT_SENSOR     = 0x00008000u, /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
		SDL_INIT_CAMERA     = 0x00010000u /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
	}

	public typealias SDL_MainThreadCallback = function void(void* userdata);

	public const c_char* SDL_PROP_APP_METADATA_NAME_STRING = "SDL.app.metadata.name";
	public const c_char* SDL_PROP_APP_METADATA_VERSION_STRING = "SDL.app.metadata.version";
	public const c_char* SDL_PROP_APP_METADATA_IDENTIFIER_STRING = "SDL.app.metadata.identifier";
	public const c_char* SDL_PROP_APP_METADATA_CREATOR_STRING = "SDL.app.metadata.creator";
	public const c_char* SDL_PROP_APP_METADATA_COPYRIGHT_STRING = "SDL.app.metadata.copyright";
	public const c_char* SDL_PROP_APP_METADATA_URL_STRING = "SDL.app.metadata.url";
	public const c_char* SDL_PROP_APP_METADATA_TYPE_STRING = "SDL.app.metadata.type";

	[CLink] public static extern c_bool SDL_Init(SDL_InitFlags flags);

	[CLink] public static extern c_bool SDL_InitSubSystem(SDL_InitFlags flags);

	[CLink] public static extern void SDL_QuitSubSystem(SDL_InitFlags flags);

	[CLink] public static extern SDL_InitFlags SDL_WasInit(SDL_InitFlags flags);

	[CLink] public static extern void SDL_Quit();

	[CLink] public static extern c_bool SDL_SetAppMetadata(c_char* appname, c_char* appversion, c_char* appidentifier);

	[CLink] public static extern c_bool SDL_SetAppMetadataProperty(c_char* name, c_char* value);

	[CLink] public static extern c_char* SDL_GetAppMetadataProperty(c_char* name);

	[CLink] public static extern c_bool SDL_IsMainThread();

	[CLink] public static extern c_bool SDL_RunOnMainThread(SDL_MainThreadCallback callback, void* userdata, c_bool wait_complete);

	//SDL_iostream.h

	[CRepr]
	public struct SDL_IOStreamInterface
	{
		/* The version of this interface */
		public uint32 version;

		/**
		 *  Return the number of bytes in this SDL_IOStream
		 *
		 *  \return the total size of the data stream, or -1 on error.
		 */
		public function int64(void* userdata) size;

		/**
		 *  Seek to `offset` relative to `whence`, one of stdio's whence values:
		 *  SDL_IO_SEEK_SET, SDL_IO_SEEK_CUR, SDL_IO_SEEK_END
		 *
		 *  \return the final offset in the data stream, or -1 on error.
		 */
		public function int64(void* userdata, int64 offset, SDL_IOWhence whence) seek;

		/**
		 *  Read up to `size` bytes from the data stream to the area pointed
		 *  at by `ptr`.
		 *
		 *  On an incomplete read, you should set `*status` to a value from the
		 *  SDL_IOStatus enum. You do not have to explicitly set this on
		 *  a complete, successful read.
		 *
		 *  \return the number of bytes read
		 */
		public function c_size(void* userdata, void* ptr, c_size size, SDL_IOStatus* status) read;

		/**
		 *  Write exactly `size` bytes from the area pointed at by `ptr`
		 *  to data stream.
		 *
		 *  On an incomplete write, you should set `*status` to a value from the
		 *  SDL_IOStatus enum. You do not have to explicitly set this on
		 *  a complete, successful write.
		 *
		 *  \return the number of bytes written
		 */
		public function c_size(void* userdata, void* ptr, c_size size, SDL_IOStatus* status) write;

		/**
		 *  If the stream is buffering, make sure the data is written out.
		 *
		 *  On failure, you should set `*status` to a value from the
		 *  SDL_IOStatus enum. You do not have to explicitly set this on
		 *  a successful flush.
		 *
		 *  \return true if successful or false on write error when flushing data.
		 */
		public function c_bool(void* userdata, SDL_IOStatus* status) flush;

		/**
		 *  Close and free any allocated resources.
		 *
		 *  This does not guarantee file writes will sync to physical media; they
		 *  can be in the system's file cache, waiting to go to disk.
		 *
		 *  The SDL_IOStream is still destroyed even if this fails, so clean up anything
		 *  even if flushing buffers, etc, returns an error.
		 *
		 *  \return true if successful or false on write error when flushing data.
		 */
		public function c_bool(void* userdata) close;
	}

	public enum SDL_IOWhence : c_int
	{
		SDL_IO_SEEK_SET, /**< Seek from the beginning of data */
		SDL_IO_SEEK_CUR, /**< Seek relative to current read poc_int*/
		SDL_IO_SEEK_END /**< Seek relative to the end of data */
	}

	public enum SDL_IOStatus : c_int
	{
		SDL_IO_STATUS_READY, /**< Everything is ready (no errors and not EOF). */
		SDL_IO_STATUS_ERROR, /**< Read or write I/O error */
		SDL_IO_STATUS_EOF, /**< End of file */
		SDL_IO_STATUS_NOT_READY, /**< Non blocking I/O, not ready */
		SDL_IO_STATUS_READONLY, /**< Tried to write a read-only buffer */
		SDL_IO_STATUS_WRITEONLY /**< Tried to read a write-only buffer */
	}

	private static void Assert_SDL_IOStreamInterface_SIZE()
	{
		Compiler.Assert((sizeof(void*) == 4 && sizeof(SDL_IOStreamInterface) == 28) ||
			(sizeof(void*) == 8 && sizeof(SDL_IOStreamInterface) == 56));
	}

	public const c_char* SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER    = "SDL.iostream.windows.handle";
	public const c_char* SDL_PROP_IOSTREAM_STDIO_FILE_POINTER        = "SDL.iostream.stdio.file";
	public const c_char* SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER    = "SDL.iostream.file_descriptor";
	public const c_char* SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER    = "SDL.iostream.android.aasset";
	public const c_char* SDL_PROP_IOSTREAM_MEMORY_POINTER = "SDL.iostream.memory.base";
	public const c_char* SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER  = "SDL.iostream.memory.size";
	public const c_char* SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER    = "SDL.iostream.dynamic.memory";
	public const c_char* SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER  = "SDL.iostream.dynamic.chunksize";

	[CLink] public static extern c_bool SDL_SaveFile_IO(SDL_IOStream* src, void* data, c_size datasize, c_bool closeio);

	[CLink] public static extern c_bool SDL_SaveFile(c_char* file, void* data, c_size datasize);

	[CLink] public static extern SDL_IOStream* SDL_IOFromFile(c_char* file, c_char* mode);

	[CLink] public static extern SDL_IOStream* SDL_IOFromMem(void* mem, c_size size);

	[CLink] public static extern SDL_IOStream* SDL_IOFromConstMem(void* mem, c_size size);

	[CLink] public static extern SDL_IOStream* SDL_IOFromDynamicMem();

	[CLink] public static extern SDL_IOStream* SDL_OpenIO(SDL_IOStreamInterface* iface, void* userdata);

	[CLink] public static extern c_bool SDL_CloseIO(SDL_IOStream* context);

	[CLink] public static extern SDL_PropertiesID SDL_GetIOProperties(SDL_IOStream* context);

	[CLink] public static extern SDL_IOStatus SDL_GetIOStatus(SDL_IOStream* context);

	[CLink] public static extern int64 SDL_GetIOSize(SDL_IOStream* context);

	[CLink] public static extern int64 SDL_SeekIO(SDL_IOStream* context, int64 offset, SDL_IOWhence whence);

	[CLink] public static extern int64 SDL_TellIO(SDL_IOStream* context);

	[CLink] public static extern c_size SDL_ReadIO(SDL_IOStream* context, void* ptr, c_size size);

	[CLink] public static extern c_size SDL_WriteIO(SDL_IOStream* context, void* ptr, c_size size);

	[CLink] public static extern c_size SDL_IOprintf(SDL_IOStream* context, c_char* fmt, ...);

	[CLink] public static extern c_size SDL_IOvprintf(SDL_IOStream* context, c_char* fmt, VarArgs ap);

	[CLink] public static extern c_bool SDL_FlushIO(SDL_IOStream* context);

	[CLink] public static extern void*  SDL_LoadFile_IO(SDL_IOStream* src, c_size* datasize, c_bool closeio);

	[CLink] public static extern void*  SDL_LoadFile(c_char* file, c_size* datasize);

	[CLink] public static extern c_bool SDL_ReadU8(SDL_IOStream* src, uint8* value);

	[CLink] public static extern c_bool SDL_ReadS8(SDL_IOStream* src, int8* value);

	[CLink] public static extern c_bool SDL_ReadU16LE(SDL_IOStream* src, uint16* value);

	[CLink] public static extern c_bool SDL_ReadS16LE(SDL_IOStream* src, int16* value);

	[CLink] public static extern c_bool SDL_ReadU16BE(SDL_IOStream* src, uint16* value);

	[CLink] public static extern c_bool SDL_ReadS16BE(SDL_IOStream* src, int16* value);

	[CLink] public static extern c_bool SDL_ReadU32LE(SDL_IOStream* src, uint32* value);

	[CLink] public static extern c_bool SDL_ReadS32LE(SDL_IOStream* src, c_int* value);

	[CLink] public static extern c_bool SDL_ReadU32BE(SDL_IOStream* src, uint32* value);

	[CLink] public static extern c_bool SDL_ReadS32BE(SDL_IOStream* src, c_int* value);

	[CLink] public static extern c_bool SDL_ReadU64LE(SDL_IOStream* src, uint64* value);

	[CLink] public static extern c_bool SDL_ReadS64LE(SDL_IOStream* src, int64* value);

	[CLink] public static extern c_bool SDL_ReadU64BE(SDL_IOStream* src, uint64* value);

	[CLink] public static extern c_bool SDL_ReadS64BE(SDL_IOStream* src, int64* value);

	[CLink] public static extern c_bool SDL_WriteU8(SDL_IOStream* dst, uint8 value);

	[CLink] public static extern c_bool SDL_WriteS8(SDL_IOStream* dst, int8 value);

	[CLink] public static extern c_bool SDL_WriteU16LE(SDL_IOStream* dst, uint16 value);

	[CLink] public static extern c_bool SDL_WriteS16LE(SDL_IOStream* dst, int16 value);

	[CLink] public static extern c_bool SDL_WriteU16BE(SDL_IOStream* dst, uint16 value);

	[CLink] public static extern c_bool SDL_WriteS16BE(SDL_IOStream* dst, int16 value);

	[CLink] public static extern c_bool SDL_WriteU32LE(SDL_IOStream* dst, uint32 value);

	[CLink] public static extern c_bool SDL_WriteS32LE(SDL_IOStream* dst, c_int value);

	[CLink] public static extern c_bool SDL_WriteU32BE(SDL_IOStream* dst, uint32 value);

	[CLink] public static extern c_bool SDL_WriteS32BE(SDL_IOStream* dst, c_int value);

	[CLink] public static extern c_bool SDL_WriteU64LE(SDL_IOStream* dst, uint64 value);

	[CLink] public static extern c_bool SDL_WriteS64LE(SDL_IOStream* dst, int64 value);

	[CLink] public static extern c_bool SDL_WriteU64BE(SDL_IOStream* dst, uint64 value);

	[CLink] public static extern c_bool SDL_WriteS64BE(SDL_IOStream* dst, int64 value);

	//SDL_joystick.h

	typealias SDL_JoystickID = uint32;

	public enum SDL_JoystickType : c_int
	{
		SDL_JOYSTICK_TYPE_UNKNOWN,
		SDL_JOYSTICK_TYPE_GAMEPAD,
		SDL_JOYSTICK_TYPE_WHEEL,
		SDL_JOYSTICK_TYPE_ARCADE_STICK,
		SDL_JOYSTICK_TYPE_FLIGHT_STICK,
		SDL_JOYSTICK_TYPE_DANCE_PAD,
		SDL_JOYSTICK_TYPE_GUITAR,
		SDL_JOYSTICK_TYPE_DRUM_KIT,
		SDL_JOYSTICK_TYPE_ARCADE_PAD,
		SDL_JOYSTICK_TYPE_THROTTLE,
		SDL_JOYSTICK_TYPE_COUNT
	}

	[CRepr]
	public struct SDL_Joystick;

	[CRepr]
	public struct SDL_VirtualJoystickDesc
	{
		public uint32 version; /**< the version of this interface */
		public uint16 type; /**< `SDL_JoystickType` */
		public uint16 padding; /**< unused */
		public uint16 vendor_id; /**< the USB vendor ID of this joystick */
		public uint16 product_id; /**< the USB product ID of this joystick */
		public uint16 naxes; /**< the number of axes on this joystick */
		public uint16 nbuttons; /**< the number of buttons on this joystick */
		public uint16 nballs; /**< the number of balls on this joystick */
		public uint16 nhats; /**< the number of hats on this joystick */
		public uint16 ntouchpads; /**< the number of touchpads on this joystick, requires `touchpads` to poc_intat valid descriptions */
		public uint16 nsensors; /**< the number of sensors on this joystick, requires `sensors` to poc_intat valid descriptions */
		public uint16[2] padding2; /**< unused */
		public uint32 button_mask; /**< A mask of which buttons are valid for this controller
								 e.g. (1 << SDL_GAMEPAD_BUTTON_SOUTH) */
		public uint32 axis_mask; /**< A mask of which axes are valid for this controller
								 e.g. (1 << SDL_GAMEPAD_AXIS_LEFTX) */
		public c_char* name; /**< the name of the joystick */
		public SDL_VirtualJoystickTouchpadDesc* touchpads; /**< A pointer to an array of touchpad descriptions, required if `ntouchpads` is > 0 */
		public SDL_VirtualJoystickSensorDesc* sensors; /**< A pointer to an array of sensor descriptions, required if `nsensors` is > 0 */

		public void* userdata; /**< User data pointer passed to callbacks */
		public function void(void* userdata) Update; /**< Called when the joystick state should be updated */
		public function void(void* userdata, c_int player_index) SetPlayerIndex; /**< Called when the player index is set */
		public function c_bool(void* userdata, uint16 low_frequency_rumble, uint16 high_frequency_rumble) Rumble; /**< Implements SDL_RumbleJoystick() */
		public function c_bool(void* userdata, uint16 left_rumble, uint16 right_rumble) RumbleTriggers; /**< Implements SDL_RumbleJoystickTriggers() */
		public function c_bool(void* userdata, uint8 red, uint8 green, uint8 blue) SetLED; /**< Implements SDL_SetJoystickLED() */
		public function c_bool(void* userdata, void* data, c_int size) SendEffect; /**< Implements SDL_SendJoystickEffect() */
		public function c_bool(void* userdata, c_bool enabled) SetSensorsEnabled; /**< Implements SDL_SetGamepadSensorEnabled() */
		public function void(void* userdata) Cleanup; /**< Cleans up the userdata when the joystick is detached */
	}

	[CRepr]
	public struct SDL_VirtualJoystickTouchpadDesc
	{
		public uint16 nfingers; /**< the number of simultaneous fingers on this touchpad */
		public uint16[3] padding;
	}

	[CRepr]
	public struct SDL_VirtualJoystickSensorDesc
	{
		public SDL_SensorType type; /**< the type of this sensor */
		public float rate; /**< the update frequency of this sensor, may be 0.0f */
	}

	public enum SDL_JoystickConnectionState : c_int
	{
		SDL_JOYSTICK_CONNECTION_INVALID = -1,
		SDL_JOYSTICK_CONNECTION_UNKNOWN,
		SDL_JOYSTICK_CONNECTION_WIRED,
		SDL_JOYSTICK_CONNECTION_WIRELESS
	}

	public const c_int SDL_JOYSTICK_AXIS_MAX   = 32767;
	public const c_int SDL_JOYSTICK_AXIS_MIN   = -32768;

	private static void Assert_SDL_VirtualJoystickDesc_SIZE()
	{
		Compiler.Assert((sizeof(void*) == 4 && sizeof(SDL_VirtualJoystickDesc) == 84) ||
			(sizeof(void*) == 8 && sizeof(SDL_VirtualJoystickDesc) == 136));
	}

	public const c_char* SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN          = "SDL.joystick.cap.mono_led";
	public const c_char* SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN           = "SDL.joystick.cap.rgb_led";
	public const c_char* SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN        = "SDL.joystick.cap.player_led";
	public const c_char* SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN            = "SDL.joystick.cap.rumble";
	public const c_char* SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN    = "SDL.joystick.cap.trigger_rumble";

	public enum SDL_HAT : uint32
	{
		SDL_HAT_CENTERED    = 0x00,
		SDL_HAT_UP          = 0x01,
		SDL_HAT_RIGHT       = 0x02,
		SDL_HAT_DOWN        = 0x04,
		SDL_HAT_LEFT        = 0x08,
		SDL_HAT_RIGHTUP     = (SDL_HAT_RIGHT | SDL_HAT_UP),
		SDL_HAT_RIGHTDOWN   = (SDL_HAT_RIGHT | SDL_HAT_DOWN),
		SDL_HAT_LEFTUP      = (SDL_HAT_LEFT | SDL_HAT_UP),
		SDL_HAT_LEFTDOWN    = (SDL_HAT_LEFT | SDL_HAT_DOWN),
	}

	[CLink] public static extern void SDL_LockJoysticks();

	[CLink] public static extern void SDL_UnlockJoysticks();

	[CLink] public static extern c_bool SDL_HasJoystick();

	[CLink] public static extern SDL_JoystickID*  SDL_GetJoysticks(c_int* count);

	[CLink] public static extern c_char*  SDL_GetJoystickNameForID(SDL_JoystickID instance_id);

	[CLink] public static extern c_char*  SDL_GetJoystickPathForID(SDL_JoystickID instance_id);

	[CLink] public static extern c_int SDL_GetJoystickPlayerIndexForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_GUID SDL_GetJoystickGUIDForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetJoystickVendorForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetJoystickProductForID(SDL_JoystickID instance_id);

	[CLink] public static extern uint16 SDL_GetJoystickProductVersionForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_JoystickType SDL_GetJoystickTypeForID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Joystick* SDL_OpenJoystick(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Joystick* SDL_GetJoystickFromID(SDL_JoystickID instance_id);

	[CLink] public static extern SDL_Joystick* SDL_GetJoystickFromPlayerIndex(c_int player_index);

	[CLink] public static extern SDL_JoystickID SDL_AttachVirtualJoystick(SDL_VirtualJoystickDesc* desc);

	[CLink] public static extern c_bool SDL_DetachVirtualJoystick(SDL_JoystickID instance_id);

	[CLink] public static extern c_bool SDL_IsJoystickVirtual(SDL_JoystickID instance_id);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualAxis(SDL_Joystick* joystick, c_int axis, int16 value);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualBall(SDL_Joystick* joystick, c_int ball, int16 xrel, int16 yrel);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualButton(SDL_Joystick* joystick, c_int button, c_bool down);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualHat(SDL_Joystick* joystick, c_int hat, int8 value);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualTouchpad(SDL_Joystick* joystick, c_int touchpad, c_int finger, c_bool down, float x, float y, float pressure);

	[CLink] public static extern c_bool SDL_SendJoystickVirtualSensorData(SDL_Joystick* joystick, SDL_SensorType type, uint64 sensor_timestamp, float* data, c_int num_values);

	[CLink] public static extern SDL_PropertiesID SDL_GetJoystickProperties(SDL_Joystick* joystick);

	[CLink] public static extern c_char* SDL_GetJoystickName(SDL_Joystick* joystick);

	[CLink] public static extern c_char*  SDL_GetJoystickPath(SDL_Joystick* joystick);

	[CLink] public static extern c_int SDL_GetJoystickPlayerIndex(SDL_Joystick* joystick);

	[CLink] public static extern c_bool SDL_SetJoystickPlayerIndex(SDL_Joystick* joystick, c_int player_index);

	[CLink] public static extern SDL_GUID SDL_GetJoystickGUID(SDL_Joystick* joystick);

	[CLink] public static extern uint16 SDL_GetJoystickVendor(SDL_Joystick* joystick);

	[CLink] public static extern uint16 SDL_GetJoystickProduct(SDL_Joystick* joystick);

	[CLink] public static extern uint16 SDL_GetJoystickProductVersion(SDL_Joystick* joystick);

	[CLink] public static extern uint16 SDL_GetJoystickFirmwareVersion(SDL_Joystick* joystick);

	[CLink] public static extern c_char*  SDL_GetJoystickSerial(SDL_Joystick* joystick);

	[CLink] public static extern SDL_JoystickType SDL_GetJoystickType(SDL_Joystick* joystick);

	[CLink] public static extern void SDL_GetJoystickGUIDInfo(SDL_GUID guid, uint16* vendor, uint16* product, uint16* version, uint16* crc16);

	[CLink] public static extern c_bool SDL_JoystickConnected(SDL_Joystick* joystick);

	[CLink] public static extern SDL_JoystickID SDL_GetJoystickID(SDL_Joystick* joystick);

	[CLink] public static extern c_int SDL_GetNumJoystickAxes(SDL_Joystick* joystick);

	[CLink] public static extern c_int SDL_GetNumJoystickBalls(SDL_Joystick* joystick);

	[CLink] public static extern c_int SDL_GetNumJoystickHats(SDL_Joystick* joystick);

	[CLink] public static extern c_int SDL_GetNumJoystickButtons(SDL_Joystick* joystick);

	[CLink] public static extern void SDL_SetJoystickEventsEnabled(c_bool enabled);

	[CLink] public static extern c_bool SDL_JoystickEventsEnabled();

	[CLink] public static extern void SDL_UpdateJoysticks();

	[CLink] public static extern int16 SDL_GetJoystickAxis(SDL_Joystick* joystick, c_int axis);

	[CLink] public static extern c_bool SDL_GetJoystickAxisInitialState(SDL_Joystick* joystick, c_int axis, int16* state);

	[CLink] public static extern c_bool SDL_GetJoystickBall(SDL_Joystick* joystick, c_int ball, c_int* dx, c_int* dy);

	[CLink] public static extern uint8 SDL_GetJoystickHat(SDL_Joystick* joystick, c_int hat);

	[CLink] public static extern c_bool SDL_GetJoystickButton(SDL_Joystick* joystick, c_int button);

	[CLink] public static extern c_bool SDL_RumbleJoystick(SDL_Joystick* joystick, uint16 low_frequency_rumble, uint16 high_frequency_rumble, uint32 duration_ms);

	[CLink] public static extern c_bool SDL_RumbleJoystickTriggers(SDL_Joystick* joystick, uint16 left_rumble, uint16 right_rumble, uint32 duration_ms);

	[CLink] public static extern c_bool SDL_SetJoystickLED(SDL_Joystick* joystick, uint8 red, uint8 green, uint8 blue);

	[CLink] public static extern c_bool SDL_SendJoystickEffect(SDL_Joystick* joystick, void* data, c_int size);

	[CLink] public static extern void SDL_CloseJoystick(SDL_Joystick* joystick);

	[CLink] public static extern SDL_JoystickConnectionState SDL_GetJoystickConnectionState(SDL_Joystick* joystick);

	[CLink] public static extern SDL_PowerState SDL_GetJoystickPowerInfo(SDL_Joystick* joystick, c_int* percent);

	[CLink] public static extern c_bool SDL_SetJoystickVirtualHat(SDL_Joystick* joystick, c_int hat, uint8 value);

	//SDL_keyboard.h

	public typealias SDL_KeyboardID = uint32;


	public enum SDL_TextInputType : c_int
	{
		SDL_TEXTINPUT_TYPE_TEXT, /**< The input is text */
		SDL_TEXTINPUT_TYPE_TEXT_NAME, /**< The input is a person's name */
		SDL_TEXTINPUT_TYPE_TEXT_EMAIL, /**< The input is an e-mail address */
		SDL_TEXTINPUT_TYPE_TEXT_USERNAME, /**< The input is a username */
		SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN, /**< The input is a secure password that is hidden */
		SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE, /**< The input is a secure password that is visible */
		SDL_TEXTINPUT_TYPE_NUMBER, /**< The input is a number */
		SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN, /**< The input is a secure PIN that is hidden */
		SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE /**< The input is a secure PIN that is visible */
	}

	public enum SDL_Capitalization : c_int
	{
		SDL_CAPITALIZE_NONE, /**< No auto-capitalization will be done */
		SDL_CAPITALIZE_SENTENCES, /**< The first letter of sentences will be capitalized */
		SDL_CAPITALIZE_WORDS, /**< The first letter of words will be capitalized */
		SDL_CAPITALIZE_LETTERS /**< All letters will be capitalized */
	}


	public const c_char* SDL_PROP_TEXTINPUT_TYPE_NUMBER                  = "SDL.textinput.type";
	public const c_char* SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER        = "SDL.textinput.capitalization";
	public const c_char* SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN          = "SDL.textinput.autocorrect";
	public const c_char* SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN            = "SDL.textinput.multiline";
	public const c_char* SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER     = "SDL.textinput.android.inputtype";

	[CLink] public static extern c_bool SDL_HasKeyboard();

	[CLink] public static extern SDL_KeyboardID* SDL_GetKeyboards(c_int* count);

	[CLink] public static extern c_char* SDL_GetKeyboardNameForID(SDL_KeyboardID instance_id);

	[CLink] public static extern SDL_Window* SDL_GetKeyboardFocus();

	[CLink] public static extern c_bool* SDL_GetKeyboardState(c_int* numkeys);

	[CLink] public static extern void SDL_ResetKeyboard();

	[CLink] public static extern SDL_Keymod SDL_GetModState();

	[CLink] public static extern void SDL_SetModState(SDL_Keymod modstate);

	[CLink] public static extern SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode scancode, SDL_Keymod modstate, c_bool key_event);

	[CLink] public static extern SDL_Scancode SDL_GetScancodeFromKey(SDL_Keycode key, SDL_Keymod* modstate);

	[CLink] public static extern c_bool SDL_SetScancodeName(SDL_Scancode scancode, c_char* name);

	[CLink] public static extern c_char* SDL_GetScancodeName(SDL_Scancode scancode);

	[CLink] public static extern SDL_Scancode SDL_GetScancodeFromName(c_char* name);

	[CLink] public static extern c_char*  SDL_GetKeyName(SDL_Keycode key);

	[CLink] public static extern SDL_Keycode SDL_GetKeyFromName(c_char* name);

	[CLink] public static extern c_bool SDL_StartTextInput(SDL_Window* window);

	[CLink] public static extern c_bool SDL_StartTextInputWithProperties(SDL_Window* window, SDL_PropertiesID props);

	[CLink] public static extern c_bool SDL_TextInputActive(SDL_Window* window);

	[CLink] public static extern c_bool SDL_StopTextInput(SDL_Window* window);

	[CLink] public static extern c_bool SDL_ClearComposition(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetTextInputArea(SDL_Window* window, SDL_Rect* rect, c_int cursor);

	[CLink] public static extern c_bool SDL_GetTextInputArea(SDL_Window* window, SDL_Rect* rect, int* cursor);

	[CLink] public static extern c_bool SDL_HasScreenKeyboardSupport();

	[CLink] public static extern c_bool SDL_ScreenKeyboardShown(SDL_Window* window);

	[CLink] public static extern c_bool SDL_GetTextInputArea(SDL_Window* window, SDL_Rect* rect, c_int* cursor);

	//SDL_loadso.h

	public struct SDL_SharedObject;

	public typealias SDL_FunctionPointer = function void();

	[CLink] public static extern SDL_SharedObject* SDL_LoadObject(c_char* sofile);

	[CLink] public static extern SDL_FunctionPointer SDL_LoadFunction(SDL_SharedObject* handle, c_char* name);

	[CLink] public static extern void SDL_UnloadObject(SDL_SharedObject* handle);

	//SDL_locale.h

	[CRepr]
	public struct SDL_Locale
	{
		public c_char* language; /**< A language name, like "en" for English. */
		public c_char* country; /**< A country, like "US" for America. Can be NULL. */
	}

	[CLink] public static extern SDL_Locale** SDL_GetPreferredLocales(c_int* count);

	//SDL_log.h

	public enum SDL_LogPriority : c_int
	{
		SDL_LOG_PRIORITY_INVALID,
		SDL_LOG_PRIORITY_TRACE,
		SDL_LOG_PRIORITY_VERBOSE,
		SDL_LOG_PRIORITY_DEBUG,
		SDL_LOG_PRIORITY_INFO,
		SDL_LOG_PRIORITY_WARN,
		SDL_LOG_PRIORITY_ERROR,
		SDL_LOG_PRIORITY_CRITICAL,
		SDL_LOG_PRIORITY_COUNT
	}

	public enum SDL_LogCategory : c_int
	{
		SDL_LOG_CATEGORY_APPLICATION,
		SDL_LOG_CATEGORY_ERROR,
		SDL_LOG_CATEGORY_ASSERT,
		SDL_LOG_CATEGORY_SYSTEM,
		SDL_LOG_CATEGORY_AUDIO,
		SDL_LOG_CATEGORY_VIDEO,
		SDL_LOG_CATEGORY_RENDER,
		SDL_LOG_CATEGORY_INPUT,
		SDL_LOG_CATEGORY_TEST,
		SDL_LOG_CATEGORY_GPU,

	/* Reserved for future SDL library use */
		SDL_LOG_CATEGORY_RESERVED2,
		SDL_LOG_CATEGORY_RESERVED3,
		SDL_LOG_CATEGORY_RESERVED4,
		SDL_LOG_CATEGORY_RESERVED5,
		SDL_LOG_CATEGORY_RESERVED6,
		SDL_LOG_CATEGORY_RESERVED7,
		SDL_LOG_CATEGORY_RESERVED8,
		SDL_LOG_CATEGORY_RESERVED9,
		SDL_LOG_CATEGORY_RESERVED10,

		SDL_LOG_CATEGORY_CUSTOM
	}

	public typealias SDL_LogOutputFunction = function void(void* userdata, c_int category, SDL_LogPriority priority, c_char* message);

	[CLink] public static extern void SDL_SetLogPriorities(SDL_LogPriority priority);

	[CLink] public static extern void SDL_SetLogPriority(c_int category, SDL_LogPriority priority);

	[CLink] public static extern SDL_LogPriority SDL_GetLogPriority(c_int category);

	[CLink] public static extern void SDL_ResetLogPriorities();

	[CLink] public static extern c_bool SDL_SetLogPriorityPrefix(SDL_LogPriority priority, c_char* prefix);

	[CLink] public static extern void SDL_Log(c_char* fmt, ...);

	[CLink] public static extern void SDL_LogTrace(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogVerbose(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogDebug(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogInfo(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogWarn(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogError(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogCritical(c_int category, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogMessage(c_int category, SDL_LogPriority priority, c_char* fmt, ...);

	[CLink] public static extern void SDL_LogMessageV(c_int category, SDL_LogPriority priority, c_char* fmt, VarArgs ap);

	[CLink] public static extern SDL_LogOutputFunction SDL_GetDefaultLogOutputFunction();

	[CLink] public static extern void SDL_GetLogOutputFunction(SDL_LogOutputFunction* callback, void** userdata);

	[CLink] public static extern void SDL_SetLogOutputFunction(SDL_LogOutputFunction callback, void* userdata);

	//SDL_main.h

	public typealias SDL_main_func = function c_int(c_int argc, c_char*[] argv);

	public typealias SDL_AppInit_func = function SDL_AppResult(void** appstate, c_int argc, c_char*[] argv);

	public typealias SDL_AppIterate_func = function SDL_AppResult(void* appstate);

	public typealias SDL_AppEvent_func = function SDL_AppResult(void* appstate, SDL_Event* event);

	public typealias SDL_AppQuit_func = function void(void* appstate, SDL_AppResult result);

	public enum SDL_AppResult : c_int
	{
		SDL_APP_CONTINUE, /**< Value that requests that the app continue from the main callbacks. */
		SDL_APP_SUCCESS, /**< Value that requests termination with success from the main callbacks. */
		SDL_APP_FAILURE /**< Value that requests termination with error from the main callbacks. */
	}

	[CLink] public static extern void SDL_SetMainReady();

	[CLink] public static extern c_int SDL_RunApp(c_int argc, c_char*[] argv, SDL_main_func mainFunction, void* reserved);

	[CLink] public static extern c_int SDL_EnterAppMainCallbacks(c_int argc, c_char*[] argv, SDL_AppInit_func appinit, SDL_AppIterate_func appiter, SDL_AppEvent_func appevent, SDL_AppQuit_func appquit);

	[CLink] public static extern void SDL_GDKSuspendComplete();

	[CLink] public static extern SDL_AppResult SDL_AppInit(void** appstate, c_int argc, c_char*[] argv);

	[CLink] public static extern SDL_AppResult SDL_AppIterate(void* appstate);

	[CLink] public static extern SDL_AppResult SDL_AppEvent(void* appstate, SDL_Event* event);

	[CLink] public static extern void SDL_AppQuit(void* appstate, SDL_AppResult result);

	[CLink] public static extern c_int SDL_main(int32 argc, c_char*[] argv);

#if BF_PLATFORM_WINDOWS

	[CLink] public static extern c_bool SDL_RegisterApp(c_char* name, uint32 style, void* hInst);

	[CLink] public static extern void SDL_UnregisterApp();

#endif


	//SDL_messagebox.h

	[CRepr]
	public struct SDL_MessageBoxData
	{
		public SDL_MessageBoxFlags flags;
		public SDL_Window* window; /**< Parent window, can be NULL */
		public c_char* title; /**< UTF-8 title */
		public c_char* message; /**< UTF-8 message text */

		public c_int numbuttons;
		public SDL_MessageBoxButtonData* buttons;

		public SDL_MessageBoxColorScheme* colorScheme; /**< SDL_MessageBoxColorScheme, can be NULL to use system settings */
	}

	public enum SDL_MessageBoxFlags : uint32
	{
		SDL_MESSAGEBOX_ERROR                    = 0x00000010u, /**< error dialog */
		SDL_MESSAGEBOX_WARNING                  = 0x00000020u, /**< warning dialog */
		SDL_MESSAGEBOX_INFORMATION              = 0x00000040u, /**< informational dialog */
		SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT    = 0x00000080u, /**< buttons placed left to right */
		SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT    = 0x00000100u /**< buttons placed right to left */
	}

	[CRepr]
	public struct SDL_MessageBoxButtonData
	{
		public SDL_MessageBoxButtonFlags flags;
		public c_int buttonID; /**< User defined button id (value returned via SDL_ShowMessageBox) */
		public c_char* text; /**< The UTF-8 button text */
	}

	public enum SDL_MessageBoxButtonFlags : uint32
	{
		SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT = 0x00000001u, /**< Marks the default button when return is hit */
		SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT = 0x00000002u /**< Marks the default button when escape is hit */
	}

	[CRepr]
	public struct SDL_MessageBoxColorScheme
	{
		public SDL_MessageBoxColor[(.)SDL_MessageBoxColorType.SDL_MESSAGEBOX_COLOR_COUNT] colors;
	}

	public enum SDL_MessageBoxColorType : c_int
	{
		SDL_MESSAGEBOX_COLOR_BACKGROUND,
		SDL_MESSAGEBOX_COLOR_TEXT,
		SDL_MESSAGEBOX_COLOR_BUTTON_BORDER,
		SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND,
		SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED,
		SDL_MESSAGEBOX_COLOR_COUNT /**< Size of the colors array of SDL_MessageBoxColorScheme. */
	}

	[CRepr]
	public struct SDL_MessageBoxColor
	{
		public uint8 r;
		public uint8 g;
		public uint8 b;
	}

	[CLink] public static extern c_bool SDL_ShowMessageBox(SDL_MessageBoxData* messageboxdata, c_int* buttonid);

	[CLink] public static extern c_bool SDL_ShowSimpleMessageBox(SDL_MessageBoxFlags flags, c_char* title, c_char* message, SDL_Window* window);


	//SDL_metal.h

	public typealias SDL_MetalView = void*;

	[CLink] public static extern SDL_MetalView SDL_Metal_CreateView(SDL_Window* window);

	[CLink] public static extern void SDL_Metal_DestroyView(SDL_MetalView view);

	[CLink] public static extern void* SDL_Metal_GetLayer(SDL_MetalView view);

	//SDL_misc.h

	[CLink] public static extern c_bool SDL_OpenURL(c_char* url);

	//SDL_mouse.h

	public typealias SDL_MouseID = uint32;

	[AllowDuplicates]
	public enum SDL_MouseButtonFlags : uint32
	{
		SDL_BUTTON_LEFT     = 1,
		SDL_BUTTON_MIDDLE   = 2,
		SDL_BUTTON_RIGHT    = 3,
		SDL_BUTTON_X1       = 4,
		SDL_BUTTON_X2       = 5,

		//SDL_BUTTON_MASK(X)  = (1u << ((X)-1)),
		SDL_BUTTON_LMASK    = (1u << ((SDL_BUTTON_LEFT.Underlying) - 1)),
		SDL_BUTTON_MMASK    = (1u << ((SDL_BUTTON_MIDDLE.Underlying) - 1)),
		SDL_BUTTON_RMASK    = (1u << ((SDL_BUTTON_RIGHT.Underlying) - 1)),
		SDL_BUTTON_X1MASK   = (1u << ((SDL_BUTTON_X1.Underlying) - 1)),
		SDL_BUTTON_X2MASK   = (1u << ((SDL_BUTTON_X2.Underlying) - 1)),
	}

	[CRepr]
	public struct SDL_Cursor;

	public enum SDL_SystemCursor : c_int
	{
		SDL_SYSTEM_CURSOR_DEFAULT, /**< Default cursor. Usually an arrow. */
		SDL_SYSTEM_CURSOR_TEXT, /**< Text selection. Usually an I-beam. */
		SDL_SYSTEM_CURSOR_WAIT, /**< Wait. Usually an hourglass or watch or spinning ball. */
		SDL_SYSTEM_CURSOR_CROSSHAIR, /**< Crosshair. */
		SDL_SYSTEM_CURSOR_PROGRESS, /**< Program is busy but still interactive. Usually it's WAIT with an arrow. */
		SDL_SYSTEM_CURSOR_NWSE_RESIZE, /**< Double arrow pointing northwest and southeast. */
		SDL_SYSTEM_CURSOR_NESW_RESIZE, /**< Double arrow pointing northeast and southwest. */
		SDL_SYSTEM_CURSOR_EW_RESIZE, /**< Double arrow pointing west and east. */
		SDL_SYSTEM_CURSOR_NS_RESIZE, /**< Double arrow pointing north and south. */
		SDL_SYSTEM_CURSOR_MOVE, /**< Four pointed arrow pointing north, south, east, and west. */
		SDL_SYSTEM_CURSOR_NOT_ALLOWED, /**< Not permitted. Usually a slashed circle or crossbones. */
		SDL_SYSTEM_CURSOR_POINTER, /**< Pointer that indicates a link. Usually a pointing hand. */
		SDL_SYSTEM_CURSOR_NW_RESIZE, /**< Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE. */
		SDL_SYSTEM_CURSOR_N_RESIZE, /**< Window resize top. May be NS_RESIZE. */
		SDL_SYSTEM_CURSOR_NE_RESIZE, /**< Window resize top-right. May be NESW_RESIZE. */
		SDL_SYSTEM_CURSOR_E_RESIZE, /**< Window resize right. May be EW_RESIZE. */
		SDL_SYSTEM_CURSOR_SE_RESIZE, /**< Window resize bottom-right. May be NWSE_RESIZE. */
		SDL_SYSTEM_CURSOR_S_RESIZE, /**< Window resize bottom. May be NS_RESIZE. */
		SDL_SYSTEM_CURSOR_SW_RESIZE, /**< Window resize bottom-left. May be NESW_RESIZE. */
		SDL_SYSTEM_CURSOR_W_RESIZE, /**< Window resize left. May be EW_RESIZE. */
		SDL_SYSTEM_CURSOR_COUNT
	}

	public enum SDL_MouseWheelDirection : c_int
	{
		SDL_MOUSEWHEEL_NORMAL, /**< The scroll direction is normal */
		SDL_MOUSEWHEEL_FLIPPED /**< The scroll direction is flipped / natural */
	}

	[CLink] public static extern c_bool SDL_HasMouse();

	[CLink] public static extern SDL_MouseID* SDL_GetMice(c_int* count);

	[CLink] public static extern c_char* SDL_GetMouseNameForID(SDL_MouseID instance_id);

	[CLink] public static extern SDL_Window* SDL_GetMouseFocus();

	[CLink] public static extern SDL_MouseButtonFlags SDL_GetMouseState(float* x, float* y);

	[CLink] public static extern SDL_MouseButtonFlags SDL_GetGlobalMouseState(float* x, float* y);

	[CLink] public static extern SDL_MouseButtonFlags SDL_GetRelativeMouseState(float* x, float* y);

	[CLink] public static extern void SDL_WarpMouseInWindow(SDL_Window*  window, float x, float y);

	[CLink] public static extern c_bool SDL_WarpMouseGlobal(float x, float y);

	[CLink] public static extern c_bool SDL_SetWindowRelativeMouseMode(SDL_Window* window, c_bool enabled);

	[CLink] public static extern c_bool SDL_GetWindowRelativeMouseMode(SDL_Window* window);

	[CLink] public static extern c_bool SDL_CaptureMouse(c_bool enabled);

	[CLink] public static extern SDL_Cursor* SDL_CreateCursor(uint8*  data, c_int hot_x, c_int hot_y);

	[CLink] public static extern SDL_Cursor* SDL_CreateColorCursor(SDL_Surface* surface, uint8* mask, c_int w, c_int h, c_int hot_x, c_int hot_y);

	[CLink] public static extern SDL_Cursor* SDL_CreateSystemCursor(SDL_SystemCursor id);

	[CLink] public static extern c_bool SDL_SetCursor(SDL_Cursor* cursor);

	[CLink] public static extern SDL_Cursor* SDL_GetCursor();

	[CLink] public static extern SDL_Cursor* SDL_GetDefaultCursor();

	[CLink] public static extern void SDL_DestroyCursor(SDL_Cursor* cursor);

	[CLink] public static extern c_bool SDL_ShowCursor();

	[CLink] public static extern c_bool SDL_HideCursor();

	[CLink] public static extern c_bool SDL_CursorVisible();

	[CLink] public static extern SDL_Cursor* SDL_CreateCursor(uint8* data, uint8* mask, c_int w, c_int h, c_int hot_x, c_int hot_y);

	[CLink] public static extern SDL_Cursor* SDL_CreateColorCursor(SDL_Surface* surface, c_int hot_x, c_int hot_y);

	//SDL_mutex.h

	[CRepr]
	public struct SDL_Mutex;

	[CRepr]
	public struct SDL_RWLock;

	[CRepr]
	public struct SDL_Semaphore;

	[CRepr]
	public struct SDL_Condition;

	[CRepr]
	public struct SDL_InitState
	{
		public SDL_AtomicInt status;
		public SDL_ThreadID thread;
		public void* reserved;
	}

	public enum SDL_InitStatus : c_int
	{
		SDL_INIT_STATUS_UNINITIALIZED,
		SDL_INIT_STATUS_INITIALIZING,
		SDL_INIT_STATUS_INITIALIZED,
		SDL_INIT_STATUS_UNINITIALIZING
	}

	[CLink] public static extern SDL_Mutex* SDL_CreateMutex();

	[CLink] public static extern void SDL_LockMutex(SDL_Mutex* mutex);

	[CLink] public static extern c_bool SDL_TryLockMutex(SDL_Mutex* mutex);

	[CLink] public static extern void SDL_UnlockMutex(SDL_Mutex* mutex);

	[CLink] public static extern void SDL_DestroyMutex(SDL_Mutex* mutex);

	[CLink] public static extern SDL_RWLock* SDL_CreateRWLock();

	[CLink] public static extern void SDL_LockRWLockForReading(SDL_RWLock* rwlock);

	[CLink] public static extern void SDL_LockRWLockForWriting(SDL_RWLock* rwlock);

	[CLink] public static extern c_bool SDL_TryLockRWLockForReading(SDL_RWLock* rwlock);

	[CLink] public static extern c_bool SDL_TryLockRWLockForWriting(SDL_RWLock* rwlock);

	[CLink] public static extern void SDL_UnlockRWLock(SDL_RWLock* rwlock);

	[CLink] public static extern void SDL_DestroyRWLock(SDL_RWLock* rwlock);

	[CLink] public static extern SDL_Semaphore* SDL_CreateSemaphore(uint32 initial_value);

	[CLink] public static extern void SDL_DestroySemaphore(SDL_Semaphore* sem);

	[CLink] public static extern void SDL_WaitSemaphore(SDL_Semaphore* sem);

	[CLink] public static extern c_bool SDL_TryWaitSemaphore(SDL_Semaphore* sem);

	[CLink] public static extern c_bool SDL_WaitSemaphoreTimeout(SDL_Semaphore* sem, c_int timeoutMS);

	[CLink] public static extern void SDL_SignalSemaphore(SDL_Semaphore* sem);

	[CLink] public static extern uint32 SDL_GetSemaphoreValue(SDL_Semaphore* sem);

	[CLink] public static extern SDL_Condition* SDL_CreateCondition();

	[CLink] public static extern void SDL_DestroyCondition(SDL_Condition* cond);

	[CLink] public static extern void SDL_SignalCondition(SDL_Condition* cond);

	[CLink] public static extern void SDL_BroadcastCondition(SDL_Condition* cond);

	[CLink] public static extern void SDL_WaitCondition(SDL_Condition* cond, SDL_Mutex* mutex);

	[CLink] public static extern c_bool SDL_WaitConditionTimeout(SDL_Condition* cond, SDL_Mutex* mutex, c_int timeoutMS);

	[CLink] public static extern c_bool SDL_ShouldInit(SDL_InitState* state);

	[CLink] public static extern c_bool SDL_ShouldQuit(SDL_InitState* state);

	[CLink] public static extern void SDL_SetInitialized(SDL_InitState* state, c_bool initialized);

	//SDL_pixels.h

	[AllowDuplicates]
	public enum SDL_PixelFormat : c_int
	{
		SDL_PIXELFORMAT_UNKNOWN = 0,
		SDL_PIXELFORMAT_INDEX1LSB = 0x11100100u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_4321, 0, 1, 0), */
		SDL_PIXELFORMAT_INDEX1MSB = 0x11200100u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_1234, 0, 1, 0), */
		SDL_PIXELFORMAT_INDEX2LSB = 0x1c100200u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_4321, 0, 2, 0), */
		SDL_PIXELFORMAT_INDEX2MSB = 0x1c200200u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_1234, 0, 2, 0), */
		SDL_PIXELFORMAT_INDEX4LSB = 0x12100400u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_4321, 0, 4, 0), */
		SDL_PIXELFORMAT_INDEX4MSB = 0x12200400u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_1234, 0, 4, 0), */
		SDL_PIXELFORMAT_INDEX8 = 0x13000801u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1), */
		SDL_PIXELFORMAT_RGB332 = 0x14110801u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED8, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_332, 8, 1), */
		SDL_PIXELFORMAT_XRGB4444 = 0x15120c02u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_4444, 12, 2), */
		SDL_PIXELFORMAT_XBGR4444 = 0x15520c02u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_4444, 12, 2), */
		SDL_PIXELFORMAT_XRGB1555 = 0x15130f02u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_1555, 15, 2), */
		SDL_PIXELFORMAT_XBGR1555 = 0x15530f02u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_1555, 15, 2), */
		SDL_PIXELFORMAT_ARGB4444 = 0x15321002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_4444, 16, 2), */
		SDL_PIXELFORMAT_RGBA4444 = 0x15421002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_4444, 16, 2), */
		SDL_PIXELFORMAT_ABGR4444 = 0x15721002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_4444, 16, 2), */
		SDL_PIXELFORMAT_BGRA4444 = 0x15821002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_4444, 16, 2), */
		SDL_PIXELFORMAT_ARGB1555 = 0x15331002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_1555, 16, 2), */
		SDL_PIXELFORMAT_RGBA5551 = 0x15441002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_5551, 16, 2), */
		SDL_PIXELFORMAT_ABGR1555 = 0x15731002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_1555, 16, 2), */
		SDL_PIXELFORMAT_BGRA5551 = 0x15841002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_5551, 16, 2), */
		SDL_PIXELFORMAT_RGB565 = 0x15151002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_565, 16, 2), */
		SDL_PIXELFORMAT_BGR565 = 0x15551002u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_565, 16, 2), */
		SDL_PIXELFORMAT_RGB24 = 0x17101803u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_RGB, 0, 24, 3), */
		SDL_PIXELFORMAT_BGR24 = 0x17401803u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_BGR, 0, 24, 3), */
		SDL_PIXELFORMAT_XRGB8888 = 0x16161804u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_8888, 24, 4), */
		SDL_PIXELFORMAT_RGBX8888 = 0x16261804u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBX, SDL_PACKEDLAYOUT_8888, 24, 4), */
		SDL_PIXELFORMAT_XBGR8888 = 0x16561804u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_8888, 24, 4), */
		SDL_PIXELFORMAT_BGRX8888 = 0x16661804u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRX, SDL_PACKEDLAYOUT_8888, 24, 4), */
		SDL_PIXELFORMAT_ARGB8888 = 0x16362004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_8888, 32, 4), */
		SDL_PIXELFORMAT_RGBA8888 = 0x16462004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_8888, 32, 4), */
		SDL_PIXELFORMAT_ABGR8888 = 0x16762004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_8888, 32, 4), */
		SDL_PIXELFORMAT_BGRA8888 = 0x16862004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_8888, 32, 4), */
		SDL_PIXELFORMAT_XRGB2101010 = 0x16172004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_2101010, 32, 4), */
		SDL_PIXELFORMAT_XBGR2101010 = 0x16572004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_2101010, 32, 4), */
		SDL_PIXELFORMAT_ARGB2101010 = 0x16372004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_2101010, 32, 4), */
		SDL_PIXELFORMAT_ABGR2101010 = 0x16772004u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_2101010, 32, 4), */
		SDL_PIXELFORMAT_RGB48 = 0x18103006u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGB, 0, 48, 6), */
		SDL_PIXELFORMAT_BGR48 = 0x18403006u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGR, 0, 48, 6), */
		SDL_PIXELFORMAT_RGBA64 = 0x18204008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGBA, 0, 64, 8), */
		SDL_PIXELFORMAT_ARGB64 = 0x18304008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ARGB, 0, 64, 8), */
		SDL_PIXELFORMAT_BGRA64 = 0x18504008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGRA, 0, 64, 8), */
		SDL_PIXELFORMAT_ABGR64 = 0x18604008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ABGR, 0, 64, 8), */
		SDL_PIXELFORMAT_RGB48_FLOAT = 0x1a103006u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGB, 0, 48, 6), */
		SDL_PIXELFORMAT_BGR48_FLOAT = 0x1a403006u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGR, 0, 48, 6), */
		SDL_PIXELFORMAT_RGBA64_FLOAT = 0x1a204008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGBA, 0, 64, 8), */
		SDL_PIXELFORMAT_ARGB64_FLOAT = 0x1a304008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ARGB, 0, 64, 8), */
		SDL_PIXELFORMAT_BGRA64_FLOAT = 0x1a504008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGRA, 0, 64, 8), */
		SDL_PIXELFORMAT_ABGR64_FLOAT = 0x1a604008u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ABGR, 0, 64, 8), */
		SDL_PIXELFORMAT_RGB96_FLOAT = 0x1b10600cu,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGB, 0, 96, 12), */
		SDL_PIXELFORMAT_BGR96_FLOAT = 0x1b40600cu,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGR, 0, 96, 12), */
		SDL_PIXELFORMAT_RGBA128_FLOAT = 0x1b208010u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGBA, 0, 128, 16), */
		SDL_PIXELFORMAT_ARGB128_FLOAT = 0x1b308010u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ARGB, 0, 128, 16), */
		SDL_PIXELFORMAT_BGRA128_FLOAT = 0x1b508010u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGRA, 0, 128, 16), */
		SDL_PIXELFORMAT_ABGR128_FLOAT = 0x1b608010u,
			/* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ABGR, 0, 128, 16), */

		SDL_PIXELFORMAT_YV12 = 0x32315659u, /**< Planar mode: Y + V + U  (3 planes) */
			/* SDL_DEFINE_PIXELFOURCC('Y', 'V', '1', '2'), */
		SDL_PIXELFORMAT_IYUV = 0x56555949u, /**< Planar mode: Y + U + V  (3 planes) */
			/* SDL_DEFINE_PIXELFOURCC('I', 'Y', 'U', 'V'), */
		SDL_PIXELFORMAT_YUY2 = 0x32595559u, /**< Packed mode: Y0+U0+Y1+V0 (1 plane) */
			/* SDL_DEFINE_PIXELFOURCC('Y', 'U', 'Y', '2'), */
		SDL_PIXELFORMAT_UYVY = 0x59565955u, /**< Packed mode: U0+Y0+V0+Y1 (1 plane) */
			/* SDL_DEFINE_PIXELFOURCC('U', 'Y', 'V', 'Y'), */
		SDL_PIXELFORMAT_YVYU = 0x55595659u, /**< Packed mode: Y0+V0+Y1+U0 (1 plane) */
			/* SDL_DEFINE_PIXELFOURCC('Y', 'V', 'Y', 'U'), */
		SDL_PIXELFORMAT_NV12 = 0x3231564eu, /**< Planar mode: Y + U/V interleaved  (2 planes) */
			/* SDL_DEFINE_PIXELFOURCC('N', 'V', '1', '2'), */
		SDL_PIXELFORMAT_NV21 = 0x3132564eu, /**< Planar mode: Y + V/U interleaved  (2 planes) */
			/* SDL_DEFINE_PIXELFOURCC('N', 'V', '2', '1'), */
		SDL_PIXELFORMAT_P010 = 0x30313050u, /**< Planar mode: Y + U/V interleaved  (2 planes) */
			/* SDL_DEFINE_PIXELFOURCC('P', '0', '1', '0'), */
		SDL_PIXELFORMAT_EXTERNAL_OES = 0x2053454fu, /**< Android video texture format */
			/* SDL_DEFINE_PIXELFOURCC('O', 'E', 'S', ' ') */
		SDL_PIXELFORMAT_MJPG = 0x47504a4du, /**< Motion JPEG */
		/* SDL_DEFINE_PIXELFOURCC('M', 'J', 'P', 'G') */

		/* Aliases for RGBA byte arrays of color data, for the current platform */
		/*
		SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888,
		SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888,
		SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888,
		SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888,
		SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_RGBX8888,
		SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_XRGB8888,
		SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_BGRX8888,
		SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_XBGR8888
		*/

		SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888,
		SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888,
		SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888,
		SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888,
		SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_XBGR8888,
		SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_BGRX8888,
		SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_XRGB8888,
		SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_RGBX8888
	}

	[CRepr]
	public struct SDL_PixelFormatDetails
	{
		public SDL_PixelFormat format;
		public uint8 bits_per_pixel;
		public uint8 bytes_per_pixel;
		public uint8[2] padding;
		public uint32 Rmask;
		public uint32 Gmask;
		public uint32 Bmask;
		public uint32 Amask;
		public uint8 Rbits;
		public uint8 Gbits;
		public uint8 Bbits;
		public uint8 Abits;
		public uint8 Rshift;
		public uint8 Gshift;
		public uint8 Bshift;
		public uint8 Ashift;
	}

	[CRepr]
	public struct SDL_Palette
	{
		public c_int ncolors; /**< number of elements in `colors`. */
		public SDL_Color* colors; /**< an array of colors, `ncolors` long. */
		public uint32 version; /**< internal use only, do not touch. */
		public c_int refcount; /**< internal use only, do not touch. */
	}

	[CRepr]
	public struct SDL_Color
	{
		public uint8 r;
		public uint8 g;
		public uint8 b;
		public uint8 a;
	}

	[CRepr]
	public struct SDL_FColor
	{
		public float r;
		public float g;
		public float b;
		public float a;
	}

	[AllowDuplicates]
	public enum SDL_Colorspace : c_int
	{
		SDL_COLORSPACE_UNKNOWN = 0,

		/* sRGB is a gamma corrected colorspace, and the default colorspace for SDL rendering and 8-bit RGB surfaces */
		SDL_COLORSPACE_SRGB = 0x120005a0u, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT709,
									 SDL_TRANSFER_CHARACTERISTICS_SRGB,
									 SDL_MATRIX_COEFFICIENTS_IDENTITY,
									 SDL_CHROMA_LOCATION_NONE), */

		/* This is a linear colorspace and the default colorspace for floating point surfaces. On Windows this is the scRGB colorspace, and on Apple platforms this is kCGColorSpaceExtendedLinearSRGB for EDR content */
		SDL_COLORSPACE_SRGB_LINEAR = 0x12000500u, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709  */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT709,
									 SDL_TRANSFER_CHARACTERISTICS_LINEAR,
									 SDL_MATRIX_COEFFICIENTS_IDENTITY,
									 SDL_CHROMA_LOCATION_NONE), */

		/* HDR10 is a non-linear HDR colorspace and the default colorspace for 10-bit surfaces */
		SDL_COLORSPACE_HDR10 = 0x12002600u, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020  */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT2020,
									 SDL_TRANSFER_CHARACTERISTICS_PQ,
									 SDL_MATRIX_COEFFICIENTS_IDENTITY,
									 SDL_CHROMA_LOCATION_NONE), */

		SDL_COLORSPACE_JPEG = 0x220004c6u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT709,
									 SDL_TRANSFER_CHARACTERISTICS_BT601,
									 SDL_MATRIX_COEFFICIENTS_BT601,
									 SDL_CHROMA_LOCATION_NONE), */

		SDL_COLORSPACE_BT601_LIMITED = 0x211018c6u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_LIMITED,
									 SDL_COLOR_PRIMARIES_BT601,
									 SDL_TRANSFER_CHARACTERISTICS_BT601,
									 SDL_MATRIX_COEFFICIENTS_BT601,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_BT601_FULL = 0x221018c6u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT601,
									 SDL_TRANSFER_CHARACTERISTICS_BT601,
									 SDL_MATRIX_COEFFICIENTS_BT601,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_BT709_LIMITED = 0x21100421u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_LIMITED,
									 SDL_COLOR_PRIMARIES_BT709,
									 SDL_TRANSFER_CHARACTERISTICS_BT709,
									 SDL_MATRIX_COEFFICIENTS_BT709,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_BT709_FULL = 0x22100421u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT709,
									 SDL_TRANSFER_CHARACTERISTICS_BT709,
									 SDL_MATRIX_COEFFICIENTS_BT709,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_BT2020_LIMITED = 0x21102609u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_LIMITED,
									 SDL_COLOR_PRIMARIES_BT2020,
									 SDL_TRANSFER_CHARACTERISTICS_PQ,
									 SDL_MATRIX_COEFFICIENTS_BT2020_NCL,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_BT2020_FULL = 0x22102609u, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 */
			/* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
									 SDL_COLOR_RANGE_FULL,
									 SDL_COLOR_PRIMARIES_BT2020,
									 SDL_TRANSFER_CHARACTERISTICS_PQ,
									 SDL_MATRIX_COEFFICIENTS_BT2020_NCL,
									 SDL_CHROMA_LOCATION_LEFT), */

		SDL_COLORSPACE_RGB_DEFAULT = SDL_COLORSPACE_SRGB, /**< The default colorspace for RGB surfaces if no colorspace is specified */
		SDL_COLORSPACE_YUV_DEFAULT = SDL_COLORSPACE_JPEG /**< The default colorspace for YUV surfaces if no colorspace is specified */
	}

	public const uint8 SDL_ALPHA_OPAQUE = 255;
	public const float SDL_ALPHA_OPAQUE_FLOAT = 1.0f;
	public const uint8 SDL_ALPHA_TRANSPARENT = 0;
	public const float SDL_ALPHA_TRANSPARENT_FLOAT = 0.0f;

	public enum SDL_PixelType : c_int
	{
		SDL_PIXELTYPE_UNKNOWN,
		SDL_PIXELTYPE_INDEX1,
		SDL_PIXELTYPE_INDEX4,
		SDL_PIXELTYPE_INDEX8,
		SDL_PIXELTYPE_PACKED8,
		SDL_PIXELTYPE_PACKED16,
		SDL_PIXELTYPE_PACKED32,
		SDL_PIXELTYPE_ARRAYU8,
		SDL_PIXELTYPE_ARRAYU16,
		SDL_PIXELTYPE_ARRAYU32,
		SDL_PIXELTYPE_ARRAYF16,
		SDL_PIXELTYPE_ARRAYF32,
	/* appended at the end for compatibility with sdl2-compat:  */
		SDL_PIXELTYPE_INDEX2
	}

	public enum SDL_BitmapOrder : c_int
	{
		SDL_BITMAPORDER_NONE,
		SDL_BITMAPORDER_4321,
		SDL_BITMAPORDER_1234
	}

	public enum SDL_PackedOrder : c_int
	{
		SDL_PACKEDORDER_NONE,
		SDL_PACKEDORDER_XRGB,
		SDL_PACKEDORDER_RGBX,
		SDL_PACKEDORDER_ARGB,
		SDL_PACKEDORDER_RGBA,
		SDL_PACKEDORDER_XBGR,
		SDL_PACKEDORDER_BGRX,
		SDL_PACKEDORDER_ABGR,
		SDL_PACKEDORDER_BGRA
	}

	public enum SDL_ArrayOrder : c_int
	{
		SDL_ARRAYORDER_NONE,
		SDL_ARRAYORDER_RGB,
		SDL_ARRAYORDER_RGBA,
		SDL_ARRAYORDER_ARGB,
		SDL_ARRAYORDER_BGR,
		SDL_ARRAYORDER_BGRA,
		SDL_ARRAYORDER_ABGR
	}

	public enum SDL_PackedLayout : c_int
	{
		SDL_PACKEDLAYOUT_NONE,
		SDL_PACKEDLAYOUT_332,
		SDL_PACKEDLAYOUT_4444,
		SDL_PACKEDLAYOUT_1555,
		SDL_PACKEDLAYOUT_5551,
		SDL_PACKEDLAYOUT_565,
		SDL_PACKEDLAYOUT_8888,
		SDL_PACKEDLAYOUT_2101010,
		SDL_PACKEDLAYOUT_1010102
	}

	public static SDL_PixelFormat SDL_DEFINE_PIXELFOURCC(c_char A, c_char B, c_char C, c_char D) => (SDL_PixelFormat)SDL_FOURCC(A, B, C, D);

	public static SDL_PixelFormat SDL_DEFINE_PIXELFORMAT(SDL_PixelType type, c_int order, SDL_PackedLayout layout, uint32 bits, uint32 bytes)
	{
		return (SDL_PixelFormat)((1 << 28) | (((int32)type) << 24) | ((order) << 20) | (((int32)layout) << 16) | ((bits) << 8) | ((bytes) << 0));
	}

	public static c_int SDL_PIXELFLAG(SDL_PixelFormat format)
	{
		return ((((int32)format) >> 28) & 0x0F);
	}

	public static SDL_PixelType SDL_PIXELTYPE(SDL_PixelFormat format)
	{
		return (SDL_PixelType)((((int32)format) >> 24) & 0x0F);
	}

	public static c_int SDL_PIXELORDER(SDL_PixelFormat format)
	{
		return ((((int32)format) >> 20) & 0x0F);
	}

	public static SDL_PackedLayout SDL_PIXELLAYOUT(SDL_PixelFormat format)
	{
		return (SDL_PackedLayout)((((int32)format) >> 16) & 0x0F);
	}

	public static c_int SDL_BITSPERPIXEL(SDL_PixelFormat format)
	{
		return (SDL_ISPIXELFORMAT_FOURCC(format) ? 0 : ((((int32)format) >> 8) & 0xFF));
	}

	public static uint32  SDL_BYTESPERPIXEL(SDL_PixelFormat format)
	{
		return (SDL_ISPIXELFORMAT_FOURCC(format) ?
			((((format) == .SDL_PIXELFORMAT_YUY2) ||
			((format) == .SDL_PIXELFORMAT_UYVY) ||
			((format) == .SDL_PIXELFORMAT_YVYU) ||
			((format) == .SDL_PIXELFORMAT_P010)) ? 2 : 1) : (uint32)((((int32)format) >> 0) & 0xFF));
	}


	public static c_bool SDL_ISPIXELFORMAT_INDEXED(SDL_PixelFormat format)
	{
		return (!SDL_ISPIXELFORMAT_FOURCC(format) &&
			((SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_INDEX1) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_INDEX2) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_INDEX4) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_INDEX8)));
	}

	public static c_bool SDL_ISPIXELFORMAT_PACKED(SDL_PixelFormat format)
	{
		return (!SDL_ISPIXELFORMAT_FOURCC(format) &&
			((SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_PACKED8) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_PACKED16) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_PACKED32)));
	}

	public static c_bool SDL_ISPIXELFORMAT_ARRAY(SDL_PixelFormat format)
	{
		return (!SDL_ISPIXELFORMAT_FOURCC(format) &&
			((SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYU8) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYU16) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYU32) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYF16) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYF32)));
	}

	public static c_bool SDL_ISPIXELFORMAT_10BIT(SDL_PixelFormat format)
	{
		return (!SDL_ISPIXELFORMAT_FOURCC(format) &&
			((SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_PACKED32) &&
			(SDL_PIXELLAYOUT(format) == .SDL_PACKEDLAYOUT_2101010)));
	}

	public static c_bool SDL_ISPIXELFORMAT_FLOAT(SDL_PixelFormat format)
	{
		return (!SDL_ISPIXELFORMAT_FOURCC(format) &&
			((SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYF16) ||
			(SDL_PIXELTYPE(format) == .SDL_PIXELTYPE_ARRAYF32)));
	}

	public static c_bool SDL_ISPIXELFORMAT_ALPHA(SDL_PixelFormat format)
	{
		return ((SDL_ISPIXELFORMAT_PACKED(format) &&
			((SDL_PIXELORDER(format) == (int32)SDL_PackedOrder.SDL_PACKEDORDER_ARGB) ||
			(SDL_PIXELORDER(format) == (int32)SDL_PackedOrder.SDL_PACKEDORDER_RGBA) ||
			(SDL_PIXELORDER(format) == (int32)SDL_PackedOrder.SDL_PACKEDORDER_ABGR) ||
			(SDL_PIXELORDER(format) == (int32)SDL_PackedOrder.SDL_PACKEDORDER_BGRA))) ||
			(SDL_ISPIXELFORMAT_ARRAY(format) &&
			((SDL_PIXELORDER(format) == (int32)SDL_ArrayOrder.SDL_ARRAYORDER_ARGB) ||
			(SDL_PIXELORDER(format) == (int32)SDL_ArrayOrder.SDL_ARRAYORDER_RGBA) ||
			(SDL_PIXELORDER(format) == (int32)SDL_ArrayOrder.SDL_ARRAYORDER_ABGR) ||
			(SDL_PIXELORDER(format) == (int32)SDL_ArrayOrder.SDL_ARRAYORDER_BGRA))));
	}


	public static c_bool SDL_ISPIXELFORMAT_FOURCC(SDL_PixelFormat format)
	{ /* The flag is set to 1 because 0x1? is not in the printable ASCII range */
		return ((format != .SDL_PIXELFORMAT_UNKNOWN) && (SDL_PIXELFLAG(format) != 1));
	}


	public enum SDL_ColorType : c_int
	{
		SDL_COLOR_TYPE_UNKNOWN = 0,
		SDL_COLOR_TYPE_RGB = 1,
		SDL_COLOR_TYPE_YCBCR = 2
	}

	public enum SDL_ColorRange : c_int
	{
		SDL_COLOR_RANGE_UNKNOWN = 0,
		SDL_COLOR_RANGE_LIMITED = 1, /**< Narrow range, e.g. 16-235 for 8-bit RGB and luma, and 16-240 for 8-bit chroma */
		SDL_COLOR_RANGE_FULL = 2 /**< Full range, e.g. 0-255 for 8-bit RGB and luma, and 1-255 for 8-bit chroma */
	}

	public enum SDL_ColorPrimaries : c_int
	{
		SDL_COLOR_PRIMARIES_UNKNOWN = 0,
		SDL_COLOR_PRIMARIES_BT709 = 1, /**< ITU-R BT.709-6 */
		SDL_COLOR_PRIMARIES_UNSPECIFIED = 2,
		SDL_COLOR_PRIMARIES_BT470M = 4, /**< ITU-R BT.470-6 System M */
		SDL_COLOR_PRIMARIES_BT470BG = 5, /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625 */
		SDL_COLOR_PRIMARIES_BT601 = 6, /**< ITU-R BT.601-7 525, SMPTE 170M */
		SDL_COLOR_PRIMARIES_SMPTE240 = 7, /**< SMPTE 240M, functionally the same as SDL_COLOR_PRIMARIES_BT601 */
		SDL_COLOR_PRIMARIES_GENERIC_FILM = 8, /**< Generic film (color filters using Illuminant C) */
		SDL_COLOR_PRIMARIES_BT2020 = 9, /**< ITU-R BT.2020-2 / ITU-R BT.2100-0 */
		SDL_COLOR_PRIMARIES_XYZ = 10, /**< SMPTE ST 428-1 */
		SDL_COLOR_PRIMARIES_SMPTE431 = 11, /**< SMPTE RP 431-2 */
		SDL_COLOR_PRIMARIES_SMPTE432 = 12, /**< SMPTE EG 432-1 / DCI P3 */
		SDL_COLOR_PRIMARIES_EBU3213 = 22, /**< EBU Tech. 3213-E */
		SDL_COLOR_PRIMARIES_CUSTOM = 31
	}

	public enum SDL_TransferCharacteristics : c_int
	{
		SDL_TRANSFER_CHARACTERISTICS_UNKNOWN = 0,
		SDL_TRANSFER_CHARACTERISTICS_BT709 = 1, /**< Rec. ITU-R BT.709-6 / ITU-R BT1361 */
		SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED = 2,
		SDL_TRANSFER_CHARACTERISTICS_GAMMA22 = 4, /**< ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM */
		SDL_TRANSFER_CHARACTERISTICS_GAMMA28 = 5, /**< ITU-R BT.470-6 System B, G */
		SDL_TRANSFER_CHARACTERISTICS_BT601 = 6, /**< SMPTE ST 170M / ITU-R BT.601-7 525 or 625 */
		SDL_TRANSFER_CHARACTERISTICS_SMPTE240 = 7, /**< SMPTE ST 240M */
		SDL_TRANSFER_CHARACTERISTICS_LINEAR = 8,
		SDL_TRANSFER_CHARACTERISTICS_LOG100 = 9,
		SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10 = 10,
		SDL_TRANSFER_CHARACTERISTICS_IEC61966 = 11, /**< IEC 61966-2-4 */
		SDL_TRANSFER_CHARACTERISTICS_BT1361 = 12, /**< ITU-R BT1361 Extended Colour Gamut */
		SDL_TRANSFER_CHARACTERISTICS_SRGB = 13, /**< IEC 61966-2-1 (sRGB or sYCC) */
		SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT = 14, /**< ITU-R BT2020 for 10-bit system */
		SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT = 15, /**< ITU-R BT2020 for 12-bit system */
		SDL_TRANSFER_CHARACTERISTICS_PQ = 16, /**< SMPTE ST 2084 for 10-, 12-, 14- and 16-bit systems */
		SDL_TRANSFER_CHARACTERISTICS_SMPTE428 = 17, /**< SMPTE ST 428-1 */
		SDL_TRANSFER_CHARACTERISTICS_HLG = 18, /**< ARIB STD-B67, known as "hybrid log-gamma" (HLG) */
		SDL_TRANSFER_CHARACTERISTICS_CUSTOM = 31
	}

	public enum SDL_MatrixCoefficients : c_int
	{
		SDL_MATRIX_COEFFICIENTS_IDENTITY = 0,
		SDL_MATRIX_COEFFICIENTS_BT709 = 1, /**< ITU-R BT.709-6 */
		SDL_MATRIX_COEFFICIENTS_UNSPECIFIED = 2,
		SDL_MATRIX_COEFFICIENTS_FCC = 4, /**< US FCC Title 47 */
		SDL_MATRIX_COEFFICIENTS_BT470BG = 5, /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as SDL_MATRIX_COEFFICIENTS_BT601 */
		SDL_MATRIX_COEFFICIENTS_BT601 = 6, /**< ITU-R BT.601-7 525 */
		SDL_MATRIX_COEFFICIENTS_SMPTE240 = 7, /**< SMPTE 240M */
		SDL_MATRIX_COEFFICIENTS_YCGCO = 8,
		SDL_MATRIX_COEFFICIENTS_BT2020_NCL = 9, /**< ITU-R BT.2020-2 non-constant luminance */
		SDL_MATRIX_COEFFICIENTS_BT2020_CL = 10, /**< ITU-R BT.2020-2 constant luminance */
		SDL_MATRIX_COEFFICIENTS_SMPTE2085 = 11, /**< SMPTE ST 2085 */
		SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL = 12,
		SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL = 13,
		SDL_MATRIX_COEFFICIENTS_ICTCP = 14, /**< ITU-R BT.2100-0 ICTCP */
		SDL_MATRIX_COEFFICIENTS_CUSTOM = 31
	}

	public enum SDL_ChromaLocation : c_int
	{
		SDL_CHROMA_LOCATION_NONE = 0, /**< RGB, no chroma sampling */
		SDL_CHROMA_LOCATION_LEFT = 1, /**< In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically. */
		SDL_CHROMA_LOCATION_CENTER = 2, /**< In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel. */
		SDL_CHROMA_LOCATION_TOPLEFT = 3 /**< In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel ("co-sited", "co-located"). */
	}


	public static SDL_Colorspace SDL_DEFINE_COLORSPACE(SDL_ColorType type, SDL_ColorRange range, SDL_ColorPrimaries primaries, SDL_TransferCharacteristics transfer, SDL_MatrixCoefficients matrix, SDL_ChromaLocation chroma)
	{
		return
			(SDL_Colorspace)(((uint32)((int32)type) << 28) | ((uint32)(range) << 24) | ((uint32)(chroma) << 20) | ((uint32)(primaries) << 10) | ((uint32)(transfer) << 5) | ((uint32)(matrix) << 0));
	}

	public static SDL_ColorType SDL_COLORSPACETYPE(SDL_ColorType cspace)
	{
		return (SDL_ColorType)((((int32)cspace) >> 28) & 0x0F);
	}

	public static SDL_ColorRange SDL_COLORSPACERANGE(SDL_Colorspace cspace)
	{
		return (SDL_ColorRange)((((int32)cspace) >> 24) & 0x0F);
	}

	public static SDL_ChromaLocation SDL_COLORSPACECHROMA(SDL_Colorspace cspace)
	{
		return (SDL_ChromaLocation)((((int32)cspace) >> 20) & 0x0F);
	}

	public static SDL_ColorPrimaries SDL_COLORSPACEPRIMARIES(SDL_Colorspace cspace)
	{
		return (SDL_ColorPrimaries)((((int32)cspace) >> 10) & 0x1F);
	}

	public static SDL_TransferCharacteristics SDL_COLORSPACETRANSFER(SDL_Colorspace cspace)
	{
		return (SDL_TransferCharacteristics)((((int32)cspace) >> 5) & 0x1F);
	}

	public static SDL_MatrixCoefficients SDL_COLORSPACEMATRIX(SDL_Colorspace cspace)
	{
		return (SDL_MatrixCoefficients)(((int32)cspace) & 0x1F);
	}

	public static c_bool SDL_ISCOLORSPACE_MATRIX_BT601(SDL_Colorspace cspace)
	{
		return (SDL_COLORSPACEMATRIX(cspace) == .SDL_MATRIX_COEFFICIENTS_BT601 || SDL_COLORSPACEMATRIX(cspace) == .SDL_MATRIX_COEFFICIENTS_BT470BG);
	}

	public static c_bool SDL_ISCOLORSPACE_MATRIX_BT709(SDL_Colorspace cspace)
	{
		return (SDL_COLORSPACEMATRIX(cspace) == .SDL_MATRIX_COEFFICIENTS_BT709);
	}

	public static c_bool SDL_ISCOLORSPACE_MATRIX_BT2020_NCL(SDL_Colorspace cspace)
	{
		return (SDL_COLORSPACEMATRIX(cspace) == .SDL_MATRIX_COEFFICIENTS_BT2020_NCL);
	}

	public static c_bool SDL_ISCOLORSPACE_LIMITED_RANGE(SDL_Colorspace cspace)
	{
		return (SDL_COLORSPACERANGE(cspace) != .SDL_COLOR_RANGE_FULL);
	}

	public static c_bool SDL_ISCOLORSPACE_FULL_RANGE(SDL_Colorspace cspace)
	{
		return (SDL_COLORSPACERANGE(cspace) == .SDL_COLOR_RANGE_FULL);
	}

	[CLink] public static extern c_char*  SDL_GetPixelFormatName(SDL_PixelFormat format);

	[CLink] public static extern c_bool SDL_GetMasksForPixelFormat(SDL_PixelFormat format, c_int* bpp, uint32* Rmask, uint32* Gmask, uint32* Bmask, uint32* Amask);

	[CLink] public static extern SDL_PixelFormat SDL_GetPixelFormatForMasks(c_int bpp, uint32 Rmask, uint32 Gmask, uint32 Bmask, uint32 Amask);

	[CLink] public static extern SDL_PixelFormatDetails* SDL_GetPixelFormatDetails(SDL_PixelFormat format);

	[CLink] public static extern SDL_Palette* SDL_CreatePalette(c_int ncolors);

	[CLink] public static extern c_bool SDL_SetPaletteColors(SDL_Palette* palette, SDL_Color* colors, c_int firstcolor, c_int ncolors);

	[CLink] public static extern void SDL_DestroyPalette(SDL_Palette* palette);

	[CLink] public static extern uint32 SDL_MapRGB(SDL_PixelFormatDetails* format, SDL_Palette* palette, uint8 r, uint8 g, uint8 b);

	[CLink] public static extern uint32 SDL_MapRGBA(SDL_PixelFormatDetails* format, SDL_Palette* palette, uint8 r, uint8 g, uint8 b, uint8 a);

	[CLink] public static extern void SDL_GetRGB(uint32 pixel, SDL_PixelFormatDetails* format, SDL_Palette* palette, uint8* r, uint8* g, uint8* b);

	[CLink] public static extern void SDL_GetRGBA(uint32 pixel, SDL_PixelFormatDetails* format, SDL_Palette* palette, uint8* r, uint8* g, uint8* b, uint8* a);

	//SDL_platform.h

	[CLink] public static extern c_char* SDL_GetPlatform();

		//SDL_power.h

	public enum SDL_PowerState : c_int
	{
		SDL_POWERSTATE_ERROR = -1, /**< error determining power status */
		SDL_POWERSTATE_UNKNOWN, /**< cannot determine power status */
		SDL_POWERSTATE_ON_BATTERY, /**< Not plugged in, running on the battery */
		SDL_POWERSTATE_NO_BATTERY, /**< Plugged in, no battery available */
		SDL_POWERSTATE_CHARGING, /**< Plugged in, c_charging battery */
		SDL_POWERSTATE_CHARGED /**< Plugged in, battery c_charged */
	}

	[CLink] public static extern SDL_PowerState SDL_GetPowerInfo(c_int* seconds, c_int* percent);

		 //SDL_process.h

	public struct SDL_Process;

	public enum SDL_ProcessIO : c_int
	{
		SDL_PROCESS_STDIO_INHERITED, /**< The I/O stream is inherited from the application. */
		SDL_PROCESS_STDIO_NULL, /**< The I/O stream is ignored. */
		SDL_PROCESS_STDIO_APP, /**< The I/O stream is connected to a new SDL_IOStream that the application can read or write */
		SDL_PROCESS_STDIO_REDIRECT /**< The I/O stream is redirected to an existing SDL_IOStream. */
	}

	[CLink] public static extern SDL_Process* SDL_CreateProcess(c_char** args, c_bool pipe_stdio);

	[CLink] public static extern SDL_Process* SDL_CreateProcessWithProperties(SDL_PropertiesID props);

	[CLink] public static extern SDL_PropertiesID SDL_GetProcessProperties(SDL_Process* process);

	[CLink] public static extern void* SDL_ReadProcess(SDL_Process* process, c_size* datasize, c_int* exitcode);

	[CLink] public static extern SDL_IOStream* SDL_GetProcessInput(SDL_Process* process);

	[CLink] public static extern SDL_IOStream* SDL_GetProcessOutput(SDL_Process* process);

	[CLink] public static extern c_bool SDL_KillProcess(SDL_Process* process, c_bool force);

	[CLink] public static extern c_bool SDL_WaitProcess(SDL_Process* process, c_bool block, c_int* exitcode);

	[CLink] public static extern void SDL_DestroyProcess(SDL_Process* process);

	public const c_char* SDL_PROP_PROCESS_CREATE_ARGS_POINTER                = "SDL.process.create.args";
	public const c_char* SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER         = "SDL.process.create.environment";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDIN_NUMBER                = "SDL.process.create.stdin_option";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDIN_POINTER               = "SDL.process.create.stdin_source";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER               = "SDL.process.create.stdout_option";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDOUT_POINTER              = "SDL.process.create.stdout_source";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDERR_NUMBER               = "SDL.process.create.stderr_option";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDERR_POINTER              = "SDL.process.create.stderr_source";
	public const c_char* SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN    = "SDL.process.create.stderr_to_stdout";
	public const c_char* SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN          = "SDL.process.create.background";
	public const c_char* SDL_PROP_PROCESS_PID_NUMBER         = "SDL.process.pid";
	public const c_char* SDL_PROP_PROCESS_STDIN_POINTER      = "SDL.process.stdin";
	public const c_char* SDL_PROP_PROCESS_STDOUT_POINTER     = "SDL.process.stdout";
	public const c_char* SDL_PROP_PROCESS_STDERR_POINTER     = "SDL.process.stderr";
	public const c_char* SDL_PROP_PROCESS_BACKGROUND_BOOLEAN = "SDL.process.background";

	//SDL_properties.h

	public typealias SDL_PropertiesID = uint32;

	public typealias SDL_CleanupPropertyCallback = function void(void* userdata, void* value);

	public typealias SDL_EnumeratePropertiesCallback = function void(void* userdata, SDL_PropertiesID props, c_char* name);

	public enum SDL_PropertyType : c_int
	{
		SDL_PROPERTY_TYPE_INVALID,
		SDL_PROPERTY_TYPE_POINTER,
		SDL_PROPERTY_TYPE_STRING,
		SDL_PROPERTY_TYPE_NUMBER,
		SDL_PROPERTY_TYPE_FLOAT,
		SDL_PROPERTY_TYPE_BOOLEAN
	}

	[CLink] public static extern SDL_PropertiesID SDL_GetGlobalProperties();

	[CLink] public static extern SDL_PropertiesID SDL_CreateProperties();

	[CLink] public static extern c_bool SDL_CopyProperties(SDL_PropertiesID src, SDL_PropertiesID dst);

	[CLink] public static extern c_bool SDL_LockProperties(SDL_PropertiesID props);

	[CLink] public static extern void SDL_UnlockProperties(SDL_PropertiesID props);

	[CLink] public static extern c_bool SDL_SetPointerPropertyWithCleanup(SDL_PropertiesID props, c_char* name, void* value, SDL_CleanupPropertyCallback cleanup, void* userdata);

	[CLink] public static extern c_bool SDL_SetPointerProperty(SDL_PropertiesID props, c_char* name, void* value);

	[CLink] public static extern c_bool SDL_SetStringProperty(SDL_PropertiesID props, c_char* name, c_char* value);

	[CLink] public static extern c_bool SDL_SetNumberProperty(SDL_PropertiesID props, c_char* name, int64 value);

	[CLink] public static extern c_bool SDL_SetFloatProperty(SDL_PropertiesID props, c_char* name, float value);

	[CLink] public static extern c_bool SDL_SetBooleanProperty(SDL_PropertiesID props, c_char* name, c_bool value);

	[CLink] public static extern c_bool SDL_HasProperty(SDL_PropertiesID props, c_char* name);

	[CLink] public static extern SDL_PropertyType SDL_GetPropertyType(SDL_PropertiesID props, c_char* name);

	[CLink] public static extern void* SDL_GetPointerProperty(SDL_PropertiesID props, c_char* name, void* default_value);

	[CLink] public static extern c_char* SDL_GetStringProperty(SDL_PropertiesID props, c_char* name, c_char* default_value);

	[CLink] public static extern int64 SDL_GetNumberProperty(SDL_PropertiesID props, c_char* name, int64 default_value);

	[CLink] public static extern float SDL_GetFloatProperty(SDL_PropertiesID props, c_char* name, float default_value);

	[CLink] public static extern c_bool SDL_GetBooleanProperty(SDL_PropertiesID props, c_char* name, c_bool default_value);

	[CLink] public static extern c_bool SDL_ClearProperty(SDL_PropertiesID props, c_char* name);

	[CLink] public static extern c_bool SDL_EnumerateProperties(SDL_PropertiesID props, SDL_EnumeratePropertiesCallback callback, void* userdata);

	[CLink] public static extern void SDL_DestroyProperties(SDL_PropertiesID props);

	//SDL_rect.h

	[CRepr]
	public struct SDL_Rect
	{
		public c_int x;
		public c_int y;
		public c_int w;
		public c_int h;
	}

	[CRepr]
	public struct SDL_Point
	{
		public c_int x;
		public c_int y;
	}

	[CRepr]
	public struct SDL_FRect
	{
		public float x;
		public float y;
		public float w;
		public float h;
	}

	[CRepr]
	public struct SDL_FPoint
	{
		public c_int x;
		public c_int y;
	}

	[Inline] public static void SDL_RectToFRect(SDL_Rect* rect, SDL_FRect* frect)
	{
		frect.x = (float)rect.x;
		frect.y = (float)rect.y;
		frect.w = (float)rect.w;
		frect.h = (float)rect.h;
	}

	[Inline] public static c_bool SDL_PointInRect(SDL_Point* p, SDL_Rect* r)
	{
		return (p != null && r != null && (p.x >= r.x) && (p.x < (r.x + r.w)) &&
			(p.y >= r.y) && (p.y < (r.y + r.h))) ? true : false;
	}

	[Inline] public static c_bool SDL_RectEmpty(SDL_Rect* r)
	{
		return ((r == null) || (r.w <= 0) || (r.h <= 0)) ? true : false;
	}

	[Inline] public static c_bool SDL_RectsEqual(SDL_Rect* a, SDL_Rect* b)
	{
		return (a != null && b != null && (a.x == b.x) && (a.y == b.y) &&
			(a.w == b.w) && (a.h == b.h)) ? true : false;
	}

	[Inline] public static c_bool SDL_PointInRectFloat(SDL_FPoint* p, SDL_FRect* r)
	{
		return (p != null && r != null && (p.x >= r.x) && (p.x <= (r.x + r.w)) &&
			(p.y >= r.y) && (p.y <= (r.y + r.h))) ? true : false;
	}

	[Inline] public static c_bool SDL_RectEmptyFloat(SDL_FRect* r)
	{
		return ((r == null) || (r.w < 0.0f) || (r.h < 0.0f)) ? true : false;
	}

	[Inline] public static c_bool SDL_RectsEqualEpsilon(SDL_FRect* a, SDL_FRect* b, float epsilon)
	{
		return (a != null && b != null && ((a == b) ||
			((SDL_fabsf(a.x - b.x) <= epsilon) &&
			(SDL_fabsf(a.y - b.y) <= epsilon) &&
			(SDL_fabsf(a.w - b.w) <= epsilon) &&
			(SDL_fabsf(a.h - b.h) <= epsilon))))
			? true : false;
	}

	[Inline] public static c_bool SDL_RectsEqualFloat(SDL_FRect* a, SDL_FRect* b)
	{
		return SDL_RectsEqualEpsilon(a, b, SDL_FLT_EPSILON);
	}

	[CLink] public static extern c_bool SDL_HasRectIntersection(SDL_Rect* A, SDL_Rect* B);

	[CLink] public static extern c_bool SDL_GetRectIntersection(SDL_Rect* A, SDL_Rect* B, SDL_Rect* result);

	[CLink] public static extern c_bool SDL_GetRectUnion(SDL_Rect* A, SDL_Rect* B, SDL_Rect* result);

	[CLink] public static extern c_bool SDL_GetRectEnclosingPoints(SDL_Point* points, c_int count, SDL_Rect* clip, SDL_Rect* result);

	[CLink] public static extern c_bool SDL_GetRectAndLineIntersection(SDL_Rect* rect, c_int* X1, c_int* Y1, c_int* X2, c_int* Y2);

	[CLink] public static extern c_bool SDL_HasRectIntersectionFloat(SDL_FRect* A, SDL_FRect* B);

	[CLink] public static extern c_bool SDL_GetRectIntersectionFloat(SDL_FRect* A, SDL_FRect* B, SDL_FRect* result);

	[CLink] public static extern c_bool SDL_GetRectUnionFloat(SDL_FRect* A, SDL_FRect* B, SDL_FRect* result);

	[CLink] public static extern c_bool SDL_GetRectEnclosingPointsFloat(SDL_FPoint* points, c_int count, SDL_FRect* clip, SDL_FRect* result);

	[CLink] public static extern c_bool SDL_GetRectAndLineIntersectionFloat(SDL_FRect* rect, float* X1, float* Y1, float* X2, float* Y2);

		 //SDL_render.h

	public struct SDL_Renderer;

	public enum SDL_RendererLogicalPresentation : c_int
	{
		SDL_LOGICAL_PRESENTATION_DISABLED, /**< There is no logical size in effect */
		SDL_LOGICAL_PRESENTATION_STRETCH, /**< The rendered content is stretched to the output resolution */
		SDL_LOGICAL_PRESENTATION_LETTERBOX, /**< The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars */
		SDL_LOGICAL_PRESENTATION_OVERSCAN, /**< The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds */
		SDL_LOGICAL_PRESENTATION_INTEGER_SCALE /**< The rendered content is scaled up by integer multiples to fit the output resolution */
	}

	[CRepr]
	public struct SDL_Texture
	{
		public SDL_PixelFormat format; /**< The format of the texture, read-only */
		public c_int w; /**< The width of the texture, read-only. */
		public c_int h; /**< The height of the texture, read-only. */

		public c_int refcount; /**< Application reference count, used when freeing texture */
	}

	public enum SDL_TextureAccess : c_int
	{
		SDL_TEXTUREACCESS_STATIC, /**< Changes rarely, not lockable */
		SDL_TEXTUREACCESS_STREAMING, /**< Changes frequently, lockable */
		SDL_TEXTUREACCESS_TARGET /**< Texture can be used as a render target */
	}

	[CRepr]
	public struct SDL_Vertex
	{
		public SDL_FPoint position; /**< Vertex position, in SDL_Renderer coordinates  */
		public SDL_FColor color; /**< Vertex color */
		public SDL_FPoint tex_coord; /**< Normalized texture coordinates, if needed */
	}

	public const c_char* SDL_SOFTWARE_RENDERER   = "software";

	public const c_char* SDL_PROP_RENDERER_CREATE_NAME_STRING                                = "SDL.renderer.create.name";
	public const c_char* SDL_PROP_RENDERER_CREATE_WINDOW_POINTER                             = "SDL.renderer.create.window";
	public const c_char* SDL_PROP_RENDERER_CREATE_SURFACE_POINTER                            = "SDL.renderer.create.surface";
	public const c_char* SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER                   = "SDL.renderer.create.output_colorspace";
	public const c_char* SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER                       = "SDL.renderer.create.present_vsync";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER                    = "SDL.renderer.create.vulkan.instance";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER                      = "SDL.renderer.create.vulkan.surface";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER             = "SDL.renderer.create.vulkan.physical_device";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER                      = "SDL.renderer.create.vulkan.device";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER  = "SDL.renderer.create.vulkan.graphics_queue_family_index";
	public const c_char* SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER   = "SDL.renderer.create.vulkan.present_queue_family_index";
	public const c_char* SDL_PROP_RENDERER_NAME_STRING                               = "SDL.renderer.name";
	public const c_char* SDL_PROP_RENDERER_WINDOW_POINTER                            = "SDL.renderer.window";
	public const c_char* SDL_PROP_RENDERER_SURFACE_POINTER                           = "SDL.renderer.surface";
	public const c_char* SDL_PROP_RENDERER_VSYNC_NUMBER                              = "SDL.renderer.vsync";
	public const c_char* SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER                   = "SDL.renderer.max_texture_size";
	public const c_char* SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER                   = "SDL.renderer.texture_formats";
	public const c_char* SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER                  = "SDL.renderer.output_colorspace";
	public const c_char* SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN                       = "SDL.renderer.HDR_enabled";
	public const c_char* SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT                     = "SDL.renderer.SDR_white_point";
	public const c_char* SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT                        = "SDL.renderer.HDR_headroom";
	public const c_char* SDL_PROP_RENDERER_D3D9_DEVICE_POINTER                       = "SDL.renderer.d3d9.device";
	public const c_char* SDL_PROP_RENDERER_D3D11_DEVICE_POINTER                      = "SDL.renderer.d3d11.device";
	public const c_char* SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER                   = "SDL.renderer.d3d11.swap_chain";
	public const c_char* SDL_PROP_RENDERER_D3D12_DEVICE_POINTER                      = "SDL.renderer.d3d12.device";
	public const c_char* SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER                   = "SDL.renderer.d3d12.swap_chain";
	public const c_char* SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER               = "SDL.renderer.d3d12.command_queue";
	public const c_char* SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER                   = "SDL.renderer.vulkan.instance";
	public const c_char* SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER                     = "SDL.renderer.vulkan.surface";
	public const c_char* SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER            = "SDL.renderer.vulkan.physical_device";
	public const c_char* SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER                     = "SDL.renderer.vulkan.device";
	public const c_char* SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER = "SDL.renderer.vulkan.graphics_queue_family_index";
	public const c_char* SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER  = "SDL.renderer.vulkan.present_queue_family_index";
	public const c_char* SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER       = "SDL.renderer.vulkan.swapchain_image_count";
	public const c_char* SDL_PROP_RENDERER_GPU_DEVICE_POINTER                        = "SDL.renderer.gpu.device";
	public const c_char* SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER           = "SDL.texture.create.colorspace";
	public const c_char* SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER               = "SDL.texture.create.format";
	public const c_char* SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER               = "SDL.texture.create.access";
	public const c_char* SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER                = "SDL.texture.create.width";
	public const c_char* SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER               = "SDL.texture.create.height";
	public const c_char* SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT       = "SDL.texture.create.SDR_white_point";
	public const c_char* SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT          = "SDL.texture.create.HDR_headroom";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER       = "SDL.texture.create.d3d11.texture";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER     = "SDL.texture.create.d3d11.texture_u";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER     = "SDL.texture.create.d3d11.texture_v";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER       = "SDL.texture.create.d3d12.texture";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER     = "SDL.texture.create.d3d12.texture_u";
	public const c_char* SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER     = "SDL.texture.create.d3d12.texture_v";
	public const c_char* SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER   = "SDL.texture.create.metal.pixelbuffer";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER       = "SDL.texture.create.opengl.texture";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER    = "SDL.texture.create.opengl.texture_uv";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER     = "SDL.texture.create.opengl.texture_u";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER     = "SDL.texture.create.opengl.texture_v";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER    = "SDL.texture.create.opengles2.texture";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER = "SDL.texture.create.opengles2.texture_uv";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER  = "SDL.texture.create.opengles2.texture_u";
	public const c_char* SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER  = "SDL.texture.create.opengles2.texture_v";
	public const c_char* SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER       = "SDL.texture.create.vulkan.texture";
	public const c_char* SDL_PROP_TEXTURE_COLORSPACE_NUMBER                  = "SDL.texture.colorspace";
	public const c_char* SDL_PROP_TEXTURE_FORMAT_NUMBER                      = "SDL.texture.format";
	public const c_char* SDL_PROP_TEXTURE_ACCESS_NUMBER                      = "SDL.texture.access";
	public const c_char* SDL_PROP_TEXTURE_WIDTH_NUMBER                       = "SDL.texture.width";
	public const c_char* SDL_PROP_TEXTURE_HEIGHT_NUMBER                      = "SDL.texture.height";
	public const c_char* SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT              = "SDL.texture.SDR_white_point";
	public const c_char* SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT                 = "SDL.texture.HDR_headroom";
	public const c_char* SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER              = "SDL.texture.d3d11.texture";
	public const c_char* SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER            = "SDL.texture.d3d11.texture_u";
	public const c_char* SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER            = "SDL.texture.d3d11.texture_v";
	public const c_char* SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER              = "SDL.texture.d3d12.texture";
	public const c_char* SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER            = "SDL.texture.d3d12.texture_u";
	public const c_char* SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER            = "SDL.texture.d3d12.texture_v";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER              = "SDL.texture.opengl.texture";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER           = "SDL.texture.opengl.texture_uv";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER            = "SDL.texture.opengl.texture_u";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER            = "SDL.texture.opengl.texture_v";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER       = "SDL.texture.opengl.target";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT                 = "SDL.texture.opengl.tex_w";
	public const c_char* SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT                 = "SDL.texture.opengl.tex_h";
	public const c_char* SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER           = "SDL.texture.opengles2.texture";
	public const c_char* SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER        = "SDL.texture.opengles2.texture_uv";
	public const c_char* SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER         = "SDL.texture.opengles2.texture_u";
	public const c_char* SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER         = "SDL.texture.opengles2.texture_v";
	public const c_char* SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER    = "SDL.texture.opengles2.target";
	public const c_char* SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER              = "SDL.texture.vulkan.texture";



	public const uint32 SDL_RENDERER_VSYNC_DISABLED = 0;
	public const uint32 SDL_RENDERER_VSYNC_ADAPTIVE = uint32(-1);
	public const uint32 SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE = 8;

	[CLink] public static extern c_int SDL_GetNumRenderDrivers();

	[CLink] public static extern c_char*  SDL_GetRenderDriver(c_int index);

	[CLink] public static extern c_bool SDL_CreateWindowAndRenderer(c_char* title, c_int width, c_int height, SDL_WindowFlags window_flags, SDL_Window** window, SDL_Renderer** renderer);

	[CLink] public static extern SDL_Renderer* SDL_CreateRenderer(SDL_Window* window, c_char* name);

	[CLink] public static extern SDL_Renderer* SDL_CreateRendererWithProperties(SDL_PropertiesID props);

	[CLink] public static extern SDL_Renderer* SDL_CreateSoftwareRenderer(SDL_Surface* surface);

	[CLink] public static extern SDL_Renderer* SDL_GetRenderer(SDL_Window* window);

	[CLink] public static extern SDL_Window* SDL_GetRenderWindow(SDL_Renderer* renderer);

	[CLink] public static extern c_char* SDL_GetRendererName(SDL_Renderer* renderer);

	[CLink] public static extern SDL_PropertiesID SDL_GetRendererProperties(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_GetRenderOutputSize(SDL_Renderer* renderer, c_int* w, c_int* h);

	[CLink] public static extern c_bool SDL_GetCurrentRenderOutputSize(SDL_Renderer* renderer, c_int* w, c_int* h);

	[CLink] public static extern SDL_Texture* SDL_CreateTexture(SDL_Renderer* renderer, SDL_PixelFormat format, SDL_TextureAccess access, c_int w, c_int h);

	[CLink] public static extern SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer* renderer, SDL_Surface* surface);

	[CLink] public static extern SDL_Texture* SDL_CreateTextureWithProperties(SDL_Renderer* renderer, SDL_PropertiesID props);

	[CLink] public static extern SDL_PropertiesID SDL_GetTextureProperties(SDL_Texture* texture);

	[CLink] public static extern SDL_Renderer* SDL_GetRendererFromTexture(SDL_Texture* texture);

	[CLink] public static extern c_bool SDL_GetTextureSize(SDL_Texture* texture, float* w, float* h);

	[CLink] public static extern c_bool SDL_SetTextureColorMod(SDL_Texture* texture, uint8 r, uint8 g, uint8 b);

	[CLink] public static extern c_bool SDL_SetTextureColorModFloat(SDL_Texture* texture, float r, float g, float b);

	[CLink] public static extern c_bool SDL_GetTextureColorMod(SDL_Texture* texture, uint8* r, uint8* g, uint8* b);

	[CLink] public static extern c_bool SDL_GetTextureColorModFloat(SDL_Texture* texture, float* r, float* g, float* b);

	[CLink] public static extern c_bool SDL_SetTextureAlphaMod(SDL_Texture* texture, uint8 alpha);

	[CLink] public static extern c_bool SDL_SetTextureAlphaModFloat(SDL_Texture* texture, float alpha);

	[CLink] public static extern c_bool SDL_GetTextureAlphaMod(SDL_Texture* texture, uint8* alpha);

	[CLink] public static extern c_bool SDL_GetTextureAlphaModFloat(SDL_Texture* texture, float* alpha);

	[CLink] public static extern c_bool SDL_SetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode blendMode);

	[CLink] public static extern c_bool SDL_GetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode* blendMode);

	[CLink] public static extern c_bool SDL_SetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode scaleMode);

	[CLink] public static extern c_bool SDL_GetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode* scaleMode);

	[CLink] public static extern c_bool SDL_UpdateTexture(SDL_Texture* texture, SDL_Rect* rect, void* pixels, c_int pitch);

	[CLink] public static extern c_bool SDL_UpdateYUVTexture(SDL_Texture* texture, SDL_Rect* rect, uint8* Yplane, c_int Ypitch, uint8* Uplane, c_int Upitch, uint8* Vplane, c_int Vpitch);

	[CLink] public static extern c_bool SDL_UpdateNVTexture(SDL_Texture* texture, SDL_Rect* rect, uint8* Yplane, c_int Ypitch, uint8* UVplane, c_int UVpitch);

	[CLink] public static extern c_bool SDL_LockTexture(SDL_Texture* texture, SDL_Rect* rect, void** pixels, c_int* pitch);

	[CLink] public static extern c_bool SDL_LockTextureToSurface(SDL_Texture* texture, SDL_Rect* rect, SDL_Surface** surface);

	[CLink] public static extern void SDL_UnlockTexture(SDL_Texture* texture);

	[CLink] public static extern c_bool SDL_SetRenderTarget(SDL_Renderer* renderer, SDL_Texture* texture);

	[CLink] public static extern SDL_Texture* SDL_GetRenderTarget(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_SetRenderLogicalPresentation(SDL_Renderer* renderer, c_int w, c_int h, SDL_RendererLogicalPresentation mode);

	[CLink] public static extern c_bool SDL_GetRenderLogicalPresentation(SDL_Renderer* renderer, c_int* w, c_int* h, SDL_RendererLogicalPresentation* mode);

	[CLink] public static extern c_bool SDL_GetRenderLogicalPresentationRect(SDL_Renderer* renderer, SDL_FRect* rect);

	[CLink] public static extern c_bool SDL_RenderCoordinatesFromWindow(SDL_Renderer* renderer, float window_x, float window_y, float* x, float* y);

	[CLink] public static extern c_bool SDL_RenderCoordinatesToWindow(SDL_Renderer* renderer, float x, float y, float* window_x, float* window_y);

	[CLink] public static extern c_bool SDL_ConvertEventToRenderCoordinates(SDL_Renderer* renderer, SDL_Event* event);

	[CLink] public static extern c_bool SDL_SetRenderViewport(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_GetRenderViewport(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_RenderViewportSet(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_GetRenderSafeArea(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_SetRenderClipRect(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_GetRenderClipRect(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_RenderClipEnabled(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_SetRenderScale(SDL_Renderer* renderer, float scaleX, float scaleY);

	[CLink] public static extern c_bool SDL_GetRenderScale(SDL_Renderer* renderer, float* scaleX, float* scaleY);

	[CLink] public static extern c_bool SDL_SetRenderDrawColor(SDL_Renderer* renderer, uint8 r, uint8 g, uint8 b, uint8 a);

	[CLink] public static extern c_bool SDL_SetRenderDrawColorFloat(SDL_Renderer* renderer, float r, float g, float b, float a);

	[CLink] public static extern c_bool SDL_GetRenderDrawColor(SDL_Renderer* renderer, uint8* r, uint8* g, uint8* b, uint8* a);

	[CLink] public static extern c_bool SDL_GetRenderDrawColorFloat(SDL_Renderer* renderer, float* r, float* g, float* b, float* a);

	[CLink] public static extern c_bool SDL_SetRenderColorScale(SDL_Renderer* renderer, float scale);

	[CLink] public static extern c_bool SDL_GetRenderColorScale(SDL_Renderer* renderer, float* scale);

	[CLink] public static extern c_bool SDL_SetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode blendMode);

	[CLink] public static extern c_bool SDL_GetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode* blendMode);

	[CLink] public static extern c_bool SDL_RenderClear(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_RenderPoint(SDL_Renderer* renderer, float x, float y);

	[CLink] public static extern c_bool SDL_RenderPoints(SDL_Renderer* renderer, SDL_FPoint* points, c_int count);

	[CLink] public static extern c_bool SDL_RenderLine(SDL_Renderer* renderer, float x1, float y1, float x2, float y2);

	[CLink] public static extern c_bool SDL_RenderLines(SDL_Renderer* renderer, SDL_FPoint* points, c_int count);

	[CLink] public static extern c_bool SDL_RenderRect(SDL_Renderer* renderer, SDL_FRect* rect);

	[CLink] public static extern c_bool SDL_RenderRects(SDL_Renderer* renderer, SDL_FRect* rects, c_int count);

	[CLink] public static extern c_bool SDL_RenderFillRect(SDL_Renderer* renderer, SDL_FRect* rect);

	[CLink] public static extern c_bool SDL_RenderFillRects(SDL_Renderer* renderer, SDL_FRect* rects, c_int count);

	[CLink] public static extern c_bool SDL_RenderTexture(SDL_Renderer* renderer, SDL_Texture* texture, SDL_FRect* srcrect, SDL_FRect* dstrect);

	[CLink] public static extern c_bool SDL_RenderTextureRotated(SDL_Renderer* renderer, SDL_Texture* texture, SDL_FRect* srcrect, SDL_FRect* dstrect, double angle, SDL_FPoint* center, SDL_FlipMode flip);

	[CLink] public static extern c_bool SDL_RenderTextureTiled(SDL_Renderer* renderer, SDL_Texture* texture, SDL_FRect* srcrect, float scale, SDL_FRect* dstrect);

	[CLink] public static extern c_bool SDL_RenderTexture9Grid(SDL_Renderer* renderer, SDL_Texture* texture, SDL_FRect* srcrect, float left_width, float right_width, float top_height, float bottom_height, float scale, SDL_FRect* dstrect);

	[CLink] public static extern c_bool SDL_RenderGeometry(SDL_Renderer* renderer, SDL_Texture* texture, SDL_Vertex* vertices, c_int num_vertices, c_int* indices, c_int num_indices);

	[CLink] public static extern c_bool SDL_RenderGeometryRaw(SDL_Renderer* renderer, SDL_Texture* texture, float* xy, c_int xy_stride, SDL_FColor* color, c_int color_stride, float* uv, c_int uv_stride, c_int num_vertices, void* indices, c_int num_indices, c_int size_indices);

	[CLink] public static extern SDL_Surface*  SDL_RenderReadPixels(SDL_Renderer* renderer, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_RenderPresent(SDL_Renderer* renderer);

	[CLink] public static extern void SDL_DestroyTexture(SDL_Texture* texture);

	[CLink] public static extern void SDL_DestroyRenderer(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_FlushRenderer(SDL_Renderer* renderer);

	[CLink] public static extern void*  SDL_GetRenderMetalLayer(SDL_Renderer* renderer);

	[CLink] public static extern void*  SDL_GetRenderMetalCommandEncoder(SDL_Renderer* renderer);

	[CLink] public static extern c_bool SDL_AddVulkanRenderSemaphores(SDL_Renderer* renderer, uint32 wait_stage_mask, int64 wait_semaphore, int64 signal_semaphore);

	[CLink] public static extern c_bool SDL_SetRenderVSync(SDL_Renderer* renderer, c_int vsync);

	[CLink] public static extern c_bool SDL_GetRenderVSync(SDL_Renderer* renderer, c_int* vsync);

	[CLink] public static extern c_bool SDL_RenderDebugText(SDL_Renderer* renderer, float x, float y, c_char* str);

	[CLink] public static extern c_bool SDL_RenderTextureAffine(SDL_Renderer* renderer, SDL_Texture* texture, SDL_FRect* srcrect, SDL_FPoint* origin, SDL_FPoint* right, SDL_FPoint* down);


		 //SDL_sensor.h

	public typealias SDL_SensorID = uint32;

	public enum SDL_SensorType : c_int
	{
		SDL_SENSOR_INVALID = -1, /**< Returned for an invalid sensor */
		SDL_SENSOR_UNKNOWN, /**< Unknown sensor type */
		SDL_SENSOR_ACCEL, /**< Accelerometer */
		SDL_SENSOR_GYRO, /**< Gyroscope */
		SDL_SENSOR_ACCEL_L, /**< Accelerometer for left Joy-Con controller and Wii nunchuk */
		SDL_SENSOR_GYRO_L, /**< Gyroscope for left Joy-Con controller */
		SDL_SENSOR_ACCEL_R, /**< Accelerometer for right Joy-Con controller */
		SDL_SENSOR_GYRO_R /**< Gyroscope for right Joy-Con controller */
	}

	public struct SDL_Sensor;

	public const float SDL_STANDARD_GRAVITY     = 9.80665f;


	[CLink] public static extern SDL_SensorID*  SDL_GetSensors(c_int* count);

	[CLink] public static extern c_char*  SDL_GetSensorNameForID(SDL_SensorID instance_id);

	[CLink] public static extern SDL_SensorType SDL_GetSensorTypeForID(SDL_SensorID instance_id);

	[CLink] public static extern c_int SDL_GetSensorNonPortableTypeForID(SDL_SensorID instance_id);

	[CLink] public static extern SDL_Sensor*  SDL_OpenSensor(SDL_SensorID instance_id);

	[CLink] public static extern SDL_Sensor*  SDL_GetSensorFromID(SDL_SensorID instance_id);

	[CLink] public static extern SDL_PropertiesID SDL_GetSensorProperties(SDL_Sensor* sensor);

	[CLink] public static extern c_char*  SDL_GetSensorName(SDL_Sensor* sensor);

	[CLink] public static extern SDL_SensorType SDL_GetSensorType(SDL_Sensor* sensor);

	[CLink] public static extern c_int SDL_GetSensorNonPortableType(SDL_Sensor* sensor);

	[CLink] public static extern SDL_SensorID SDL_GetSensorID(SDL_Sensor* sensor);

	[CLink] public static extern c_bool SDL_GetSensorData(SDL_Sensor* sensor, float* data, c_int num_values);

	[CLink] public static extern void SDL_CloseSensor(SDL_Sensor* sensor);

	[CLink] public static extern void SDL_UpdateSensors();

		 //SDL_stdinc.h

	public const uint SDL_SIZE_MAX = uint.MaxValue;

	public static uint32 SDL_FOURCC(c_char A, c_char B, c_char C, c_char D)
	{
		return (((uint32(uint8(A))) << 0) | ((uint32(uint8(B))) << 8) | ((uint32(uint8(C))) << 16) | ((uint32(uint8(D))) << 24));
	}

	public typealias SDL_Time = int64;

	public typealias SDL_iconv_t = SDL_iconv_data_t*;

	public const SDL_Time SDL_MAX_TIME = int64.MaxValue;

	public const SDL_Time SDL_MIN_TIME = int64.MinValue;

	public const float SDL_FLT_EPSILON = float.Epsilon;

	[CRepr]
	public struct SDL_iconv_data_t
	{
		public c_int src_fmt;
		public c_int dst_fmt;
	}


	public const double SDL_PI_D   = 3.141592653589793238462643383279502884; /**< pi (double) */
	public const float SDL_PI_F   = 3.141592653589793238462643383279502884F; /**< pi (float) */

	public enum SDL_ICONV : uint
	{
		SDL_ICONV_ERROR     = -1, /**< Generic error. Check SDL_GetError()? */
		SDL_ICONV_E2BIG     = -2, /**< Output buffer was too small. */
		SDL_ICONV_EILSEQ    = -3, /**< Invalid input sequence was encountered. */
		SDL_ICONV_EINVAL    = -4 /**< Incomplete input sequence was encountered. */
	}

	public typealias SDL_CompareCallback_r = function c_int(void* userdata, void* a, void* b);

	public typealias SDL_CompareCallback = function c_int(void* a, void* b);

	public struct SDL_Environment;

	public typealias SDL_malloc_func = function void(c_size size);

	public typealias SDL_calloc_func = function void*(c_size nmemb, c_size size);

	public typealias SDL_realloc_func = function void*(void* mem, c_size size);

	public typealias SDL_free_func = function void(void* mem);

	[CLink] public static extern void* SDL_malloc(c_size size);

	[CLink] public static extern void* SDL_calloc(c_size nmemb, c_size size);

	[CLink] public static extern void* SDL_realloc(void* mem, c_size size);

	[CLink] public static extern void SDL_free(void* mem);

	[CLink] public static extern void SDL_GetOriginalMemoryFunctions(SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func);

	[CLink] public static extern void SDL_GetMemoryFunctions(SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func);

	[CLink] public static extern c_bool SDL_SetMemoryFunctions(SDL_malloc_func malloc_func, SDL_calloc_func calloc_func, SDL_realloc_func realloc_func, SDL_free_func free_func);

	[CLink] public static extern void* SDL_aligned_alloc(c_size alignment, c_size size);

	[CLink] public static extern void SDL_aligned_free(void* mem);

	[CLink] public static extern c_int SDL_GetNumAllocations();

	[CLink] public static extern SDL_Environment* SDL_GetEnvironment();

	[CLink] public static extern SDL_Environment* SDL_CreateEnvironment(c_bool populated);

	[CLink] public static extern c_char* SDL_GetEnvironmentVariable(SDL_Environment* env, c_char* name);

	[CLink] public static extern c_char** SDL_GetEnvironmentVariables(SDL_Environment* env);

	[CLink] public static extern c_bool SDL_SetEnvironmentVariable(SDL_Environment* env, c_char* name, c_char* value, c_bool overwrite);

	[CLink] public static extern c_bool SDL_UnsetEnvironmentVariable(SDL_Environment* env, c_char* name);

	[CLink] public static extern void SDL_DestroyEnvironment(SDL_Environment* env);

	[CLink] public static extern c_char* SDL_getenv(c_char* name);

	[CLink] public static extern c_char* SDL_getenv_unsafe(c_char* name);

	[CLink] public static extern c_int SDL_setenv_unsafe(c_char* name, c_char* value, c_int overwrite);

	[CLink] public static extern c_int SDL_unsetenv_unsafe(c_char* name);

	[CLink] public static extern void SDL_qsort(void* base_, c_size nmemb, c_size size, SDL_CompareCallback compare);

	[CLink] public static extern void* SDL_bsearch(void* key, void* base_, c_size nmemb, c_size size, SDL_CompareCallback compare);

	[CLink] public static extern void SDL_qsort_r(void* base_, c_size nmemb, c_size size, SDL_CompareCallback_r compare, void* userdata);

	[CLink] public static extern void* SDL_bsearch_r(void* key, void* base_, c_size nmemb, c_size size, SDL_CompareCallback_r compare, void* userdata);

	[CLink] public static extern c_int SDL_abs(c_int x);

	[CLink] public static extern c_int SDL_isalpha(c_int x);

	[CLink] public static extern c_int SDL_isalnum(c_int x);

	[CLink] public static extern c_int SDL_isblank(c_int x);

	[CLink] public static extern c_int SDL_iscntrl(c_int x);

	[CLink] public static extern c_int SDL_isdigit(c_int x);

	[CLink] public static extern c_int SDL_isxdigit(c_int x);

	[CLink] public static extern c_int SDL_ispunct(c_int x);

	[CLink] public static extern c_int SDL_isspace(c_int x);

	[CLink] public static extern c_int SDL_isupper(c_int x);

	[CLink] public static extern c_int SDL_islower(c_int x);

	[CLink] public static extern c_int SDL_isprint(c_int x);

	[CLink] public static extern c_int SDL_isgraph(c_int x);

	[CLink] public static extern c_int SDL_toupper(c_int x);

	[CLink] public static extern c_int SDL_tolower(c_int x);

	[CLink] public static extern uint16 SDL_crc16(uint16 crc, void* data, c_size len);

	[CLink] public static extern uint32 SDL_crc32(uint32 crc, void* data, c_size len);

	[CLink] public static extern uint32 SDL_murmur3_32(void* data, c_size len, uint32 seed);

	[CLink] public static extern void* SDL_memcpy(void* dst, void* src, c_size len);

	[CLink] public static extern void* SDL_memmove(void* dst, void* src, c_size len);

	[CLink] public static extern void* SDL_memset(void* dst, c_int c, c_size len);

	[CLink] public static extern void* SDL_memset4(void* dst, uint32 val, c_size dwords);

	[CLink] public static extern c_int SDL_memcmp(void* s1, void* s2, c_size len);

	[CLink] public static extern c_size SDL_wcslen(c_wchar* wstr);

	[CLink] public static extern c_size SDL_wcsnlen(c_wchar* wstr, c_size maxlen);

	[CLink] public static extern c_size SDL_wcslcpy(c_wchar* dst, c_wchar* src, c_size maxlen);

	[CLink] public static extern c_size SDL_wcslcat(c_wchar* dst, c_wchar* src, c_size maxlen);

	[CLink] public static extern c_wchar* SDL_wcsdup(c_wchar* wstr);

	[CLink] public static extern c_wchar* SDL_wcsstr(c_wchar* haystack, c_wchar* needle);

	[CLink] public static extern c_wchar* SDL_wcsnstr(c_wchar* haystack, c_wchar* needle, c_size maxlen);

	[CLink] public static extern c_int SDL_wcscmp(c_wchar* str1, c_wchar* str2);

	[CLink] public static extern c_int SDL_wcsncmp(c_wchar* str1, c_wchar* str2, c_size maxlen);

	[CLink] public static extern c_int SDL_wcscasecmp(c_wchar* str1, c_wchar* str2);

	[CLink] public static extern c_int SDL_wcsncasecmp(c_wchar* str1, c_wchar* str2, c_size maxlen);

	[CLink] public static extern c_long SDL_wcstol(c_wchar* str, c_wchar** endp, c_int base_);

	[CLink] public static extern c_size SDL_strlen(c_char* str);

	[CLink] public static extern c_size SDL_strnlen(c_char* str, c_size maxlen);

	[CLink] public static extern c_size SDL_strlcpy(c_char* dst, c_char* src, c_size maxlen);

	[CLink] public static extern c_size SDL_utf8strlcpy(c_char* dst, c_char* src, c_size dst_bytes);

	[CLink] public static extern c_size SDL_strlcat(c_char* dst, c_char* src, c_size maxlen);

	//Should be equivalent to #ifndef _WIN32
#if !BF_PLATFORM_WINDOWS
	[CLink] public static extern c_char* SDL_strdup(c_char* str);
#endif

	[CLink] public static extern c_char* SDL_strndup(c_char* str, c_size maxlen);

	[CLink] public static extern c_char* SDL_strrev(c_char* str);

	[CLink] public static extern c_char* SDL_strupr(c_char* str);

	[CLink] public static extern c_char* SDL_strlwr(c_char* str);

	[CLink] public static extern c_char* SDL_strchr(c_char* str, c_int c);

	[CLink] public static extern c_char* SDL_strrchr(c_char* str, c_int c);

	[CLink] public static extern c_char* SDL_strstr(c_char* haystack, c_char* needle);

	[CLink] public static extern c_char* SDL_strnstr(c_char* haystack, c_char* needle, c_size maxlen);

	[CLink] public static extern c_char* SDL_strcasestr(c_char* haystack, c_char* needle);

	[CLink] public static extern c_char* SDL_strtok_r(c_char* s1, c_char* s2, c_char** saveptr);

	[CLink] public static extern c_size SDL_utf8strlen(c_char* str);

	[CLink] public static extern c_size SDL_utf8strnlen(c_char* str, c_size bytes);

	[CLink] public static extern c_char* SDL_itoa(c_int value, c_char* str, c_int radix);

	[CLink] public static extern c_char* SDL_uitoa(c_uint value, c_char* str, c_int radix);

	[CLink] public static extern c_char* SDL_ltoa(c_long value, c_char* str, c_int radix);

	[CLink] public static extern c_char* SDL_ultoa(c_ulong value, c_char* str, c_int radix);

	[CLink] public static extern c_int SDL_atoi(c_char* str);

	[CLink] public static extern double SDL_atof(c_char* str);

	[CLink] public static extern c_long SDL_strtol(c_char* str, c_char** endp, c_int base_);

	[CLink] public static extern c_ulong SDL_strtoul(c_char* str, c_char** endp, c_int base_);

	[CLink] public static extern double SDL_strtod(c_char* str, c_char** endp);

	[CLink] public static extern c_int SDL_strcmp(c_char* str1, c_char* str2);

	[CLink] public static extern c_int SDL_strncmp(c_char* str1, c_char* str2, c_size maxlen);

	[CLink] public static extern c_int SDL_strcasecmp(c_char* str1, c_char* str2);

	[CLink] public static extern c_int SDL_strncasecmp(c_char* str1, c_char* str2, c_size maxlen);

	[CLink] public static extern c_char* SDL_strpbrk(c_char* str, c_char* breakset);

	[CLink] public static extern uint32 SDL_StepUTF8(c_char** pstr, c_size* pslen);

	[CLink] public static extern uint32 SDL_StepBackUTF8(c_char* start, c_char** pstr);

	[CLink] public static extern c_char* SDL_UCS4ToUTF8(uint32 codepoint, c_char* dst);

	[CLink] public static extern c_int SDL_sscanf(c_char* text, c_char* fmt, ...);

	[CLink] public static extern c_int SDL_vsscanf(c_char* text, c_char* fmt, VarArgs ap);

	[CLink] public static extern c_int SDL_snprintf(c_char* text, c_size maxlen, c_char* fmt, ...);

	[CLink] public static extern c_int SDL_swprintf(c_wchar* text, c_size maxlen, c_wchar* fmt, ...);

	[CLink] public static extern c_int SDL_vsnprintf(c_char* text, c_size maxlen, c_char* fmt, VarArgs ap);

	[CLink] public static extern c_int SDL_vswprintf(c_wchar* text, c_size maxlen, c_wchar* fmt, VarArgs ap);

	[CLink] public static extern c_int SDL_asprintf(c_char** strp, c_char* fmt, ...);

	[CLink] public static extern c_int SDL_vasprintf(c_char** strp, c_char* fmt, VarArgs ap);

	[CLink] public static extern void SDL_srand(int64 seed);

	[CLink] public static extern c_int SDL_rand(int32 n);

	[CLink] public static extern float SDL_randf();

	[CLink] public static extern uint32 SDL_rand_bits();

	[CLink] public static extern c_int SDL_rand_r(uint64* state, c_int n);

	[CLink] public static extern float SDL_randf_r(uint64* state);

	[CLink] public static extern uint32 SDL_rand_bits_r(uint64* state);

	[CLink] public static extern double SDL_acos(double x);

	[CLink] public static extern float SDL_acosf(float x);

	[CLink] public static extern double SDL_asin(double x);

	[CLink] public static extern float SDL_asinf(float x);

	[CLink] public static extern double SDL_atan(double x);

	[CLink] public static extern float SDL_atanf(float x);

	[CLink] public static extern double SDL_atan2(double y, double x);

	[CLink] public static extern float SDL_atan2f(float y, float x);

	[CLink] public static extern double SDL_ceil(double x);

	[CLink] public static extern float SDL_ceilf(float x);

	[CLink] public static extern double SDL_copysign(double x, double y);

	[CLink] public static extern float SDL_copysignf(float x, float y);

	[CLink] public static extern double SDL_cos(double x);

	[CLink] public static extern float SDL_cosf(float x);

	[CLink] public static extern double SDL_exp(double x);

	[CLink] public static extern float SDL_expf(float x);

	[CLink] public static extern double SDL_fabs(double x);

	[CLink] public static extern float SDL_fabsf(float x);

	[CLink] public static extern double SDL_floor(double x);

	[CLink] public static extern float SDL_floorf(float x);

	[CLink] public static extern double SDL_trunc(double x);

	[CLink] public static extern float SDL_truncf(float x);

	[CLink] public static extern double SDL_fmod(double x, double y);

	[CLink] public static extern float SDL_fmodf(float x, float y);

	[CLink] public static extern c_int SDL_isinf(double x);

	[CLink] public static extern c_int SDL_isinff(float x);

	[CLink] public static extern c_int SDL_isnan(double x);

	[CLink] public static extern c_int SDL_isnanf(float x);

	[CLink] public static extern double SDL_log(double x);

	[CLink] public static extern float SDL_logf(float x);

	[CLink] public static extern double SDL_log10(double x);

	[CLink] public static extern float SDL_log10f(float x);

	[CLink] public static extern double SDL_modf(double x, double* y);

	[CLink] public static extern float SDL_modff(float x, float* y);

	[CLink] public static extern double SDL_pow(double x, double y);

	[CLink] public static extern float SDL_powf(float x, float y);

	[CLink] public static extern double SDL_round(double x);

	[CLink] public static extern float SDL_roundf(float x);

	[CLink] public static extern c_long SDL_lround(double x);

	[CLink] public static extern c_long SDL_lroundf(float x);

	[CLink] public static extern double SDL_scalbn(double x, c_int n);

	[CLink] public static extern float SDL_scalbnf(float x, c_int n);

	[CLink] public static extern double SDL_sin(double x);

	[CLink] public static extern float SDL_sinf(float x);

	[CLink] public static extern double SDL_sqrt(double x);

	[CLink] public static extern float SDL_sqrtf(float x);

	[CLink] public static extern double SDL_tan(double x);

	[CLink] public static extern float SDL_tanf(float x);

	[CLink] public static extern SDL_iconv_t SDL_iconv_open(c_char* tocode, c_char* fromcode);

	[CLink] public static extern c_int SDL_iconv_close(SDL_iconv_t cd);

	[CLink] public static extern c_size SDL_iconv(SDL_iconv_t cd, c_char** inbuf, c_size* inbytesleft, c_char** outbuf, c_size* outbytesleft);

	[CLink] public static extern c_char* SDL_iconv_string(c_char* tocode, c_char* fromcode, c_char* inbuf, c_size inbytesleft);

	public static uint32 SDL_min(uint32 x, uint32 y) => (((x) < (y)) ? (x) : (y));

	public static uint32 SDL_max(uint32 x, uint32 y) => (((x) > (y)) ? (x) : (y));

	public static uint32 SDL_clamp(uint32 x, uint32 a, uint32 b) => (((x) < (a)) ? (a) : (((x) > (b)) ? (b) : (x)));

	[CLink] public static extern c_char* SDL_ltoa(int64 value, c_char* str, c_int radix);

	[CLink] public static extern c_char* SDL_ultoa(uint64 value, c_char* str, c_int radix);

#if !SDL_NOLONGLONG

	[CLink] public static extern c_char* SDL_lltoa(int64 value, c_char* str, c_int radix);

	[CLink] public static extern c_char* SDL_ulltoa(uint64 value, c_char* str, c_int radix);
#endif

#if !SDL_NOLONGLONG

	[CLink] public static extern int64 SDL_strtoll(c_char* str, c_char** endp, c_int @base);

	[CLink] public static extern uint64 SDL_strtoull(c_char* str, c_char** endp, c_int @base);
#endif

	[CLink] public static extern void SDL_srand(uint64 seed);

	public static c_char* SDL_iconv_utf8_locale(c_char* S)  =>  SDL_iconv_string("", "UTF-8", S, SDL_strlen(S) + 1);

	public static uint16* SDL_iconv_utf8_ucs2(c_char* S)   =>   (uint16*)SDL_iconv_string("UCS-2", "UTF-8", S, SDL_strlen(S) + 1);

	public static uint32* SDL_iconv_utf8_ucs4(c_char* S)   =>   (uint32*)SDL_iconv_string("UCS-4", "UTF-8", S, SDL_strlen(S) + 1);

	public static c_char* SDL_iconv_wchar_utf8(c_wchar* S)   =>  SDL_iconv_string("UTF-8", "WCHAR_T", (c_char*)S, (SDL_wcslen(S) + 1) * sizeof(c_wchar));

	[Inline] public static c_bool SDL_size_mul_check_overflow(uint a, uint b, uint* ret)
	{
		if (a != 0 && b > SDL_SIZE_MAX / a)
		{
			return false;
		}
		*ret = a * b;
		return true;
	}

	[Inline] public static c_bool SDL_size_add_check_overflow(uint a, uint b, uint* ret)
	{
		if (b > SDL_SIZE_MAX - a)
		{
			return false;
		}
		*ret = a + b;
		return true;
	}
	 //SDL_storage.h

	[CRepr]
	public struct SDL_Storage;

	[CRepr]
	public struct SDL_StorageInterface
	{
		/* The version of this interface */
		public uint32 version;

		/* Called when the storage is closed */
		public function c_bool(void* userdata) close;

		/* Optional, returns whether the storage is currently ready for access */
		public function c_bool(void* userdata) ready;

		/* Enumerate a directory, optional for write-only storage */
		public function c_bool(void* userdata, c_char* path, SDL_EnumerateDirectoryCallback callback, void* callback_userdata) enumerate;

		/* Get path information, optional for write-only storage */
		public function c_bool(void* userdata, c_char* path, SDL_PathInfo* info) info;

		/* Read a file from storage, optional for write-only storage */
		public function c_bool(void* userdata, c_char* path, void* destination, uint64 length) read_file;

		/* Write a file to storage, optional for read-only storage */
		public function c_bool(void* userdata, c_char* path, void* source, uint64 length) write_file;

		/* Create a directory, optional for read-only storage */
		public function c_bool(void* userdata, c_char* path) mkdir;

		/* Remove a file or empty directory, optional for read-only storage */
		public function c_bool(void* userdata, c_char* path) remove;

		/* Rename a path, optional for read-only storage */
		public function c_bool(void* userdata, c_char* oldpath, c_char* newpath) rename;

		/* Copy a file, optional for read-only storage */
		public function c_bool(void* userdata, c_char* oldpath, c_char* newpath) copy;

		/* Get the space remaining, optional for read-only storage */
		public function uint64(void* userdata) space_remaining;
	}

	public static void Assert_SDL_StorageInterface_SIZE()
	{
		Compiler.Assert((sizeof(void*) == 4 && sizeof(SDL_StorageInterface) == 48) ||
			(sizeof(void*) == 8 && sizeof(SDL_StorageInterface) == 96));
	}

	[CLink] public static extern SDL_Storage* SDL_OpenTitleStorage(c_char* override_, SDL_PropertiesID props);

	[CLink] public static extern SDL_Storage* SDL_OpenUserStorage(c_char* org, c_char* app, SDL_PropertiesID props);

	[CLink] public static extern SDL_Storage* SDL_OpenFileStorage(c_char* path);

	[CLink] public static extern SDL_Storage* SDL_OpenStorage(SDL_StorageInterface* iface, void* userdata);

	[CLink] public static extern c_bool SDL_CloseStorage(SDL_Storage* storage);

	[CLink] public static extern c_bool SDL_StorageReady(SDL_Storage* storage);

	[CLink] public static extern c_bool SDL_GetStorageFileSize(SDL_Storage* storage, c_char* path, uint64* length);

	[CLink] public static extern c_bool SDL_ReadStorageFile(SDL_Storage* storage, c_char* path, void* destination, uint64 length);

	[CLink] public static extern c_bool SDL_WriteStorageFile(SDL_Storage* storage, c_char* path, void* source, uint64 length);

	[CLink] public static extern c_bool SDL_CreateStorageDirectory(SDL_Storage* storage, c_char* path);

	[CLink] public static extern c_bool SDL_EnumerateStorageDirectory(SDL_Storage* storage, c_char* path, SDL_EnumerateDirectoryCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_RemoveStoragePath(SDL_Storage* storage, c_char* path);

	[CLink] public static extern c_bool SDL_RenameStoragePath(SDL_Storage* storage, c_char* oldpath, c_char* newpath);

	[CLink] public static extern c_bool SDL_CopyStorageFile(SDL_Storage* storage, c_char* oldpath, c_char* newpath);

	[CLink] public static extern c_bool SDL_GetStoragePathInfo(SDL_Storage* storage, c_char* path, SDL_PathInfo* info);

	[CLink] public static extern uint64 SDL_GetStorageSpaceRemaining(SDL_Storage* storage);

	[CLink] public static extern c_char**  SDL_GlobStorageDirectory(SDL_Storage* storage, c_char* path, c_char* pattern, SDL_GlobFlags flags, c_int* count);

	//SDL_surface.h

	[CRepr]
	public struct SDL_Surface
	{
		public SDL_SurfaceFlags flags; /**< The flags of the surface, read-only */
		public SDL_PixelFormat format; /**< The format of the surface, read-only */
		public c_int w; /**< The width of the surface, read-only. */
		public c_int h; /**< The height of the surface, read-only. */
		public c_int pitch; /**< The distance in bytes between rows of pixels, read-only */
		public void* pixels; /**< A pointer to the pixels of the surface, the pixels are writeable if non-NULL */

		public c_int refcount; /**< Application reference count, used when freeing surface */

		public void* reserved; /**< Reserved for internal use */
	}

	public enum SDL_SurfaceFlags : uint32
	{
		SDL_SURFACE_PREALLOCATED    = 0x00000001u, /**< Surface uses preallocated pixel memory */
		SDL_SURFACE_LOCK_NEEDED     = 0x00000002u, /**< Surface needs to be locked to access pixels */
		SDL_SURFACE_LOCKED          = 0x00000004u, /**< Surface is currently locked */
		SDL_SURFACE_SIMD_ALIGNED    = 0x00000008u /**< Surface uses pixel memory allocated with SDL_aligned_alloc() */
	}

	public enum SDL_ScaleMode : c_int
	{
		SDL_SCALEMODE_INVALID = -1,
		SDL_SCALEMODE_NEAREST, /**< nearest pixel sampling */
		SDL_SCALEMODE_LINEAR /**< linear filtering */
	}

	public enum SDL_FlipMode : c_int
	{
		SDL_FLIP_NONE, /**< Do not flip */
		SDL_FLIP_HORIZONTAL, /**< flip horizontally */
		SDL_FLIP_VERTICAL /**< flip vertically */
	}

	public static c_bool SDL_MUSTLOCK(SDL_Surface S)
	{
		return ((S.flags & .SDL_SURFACE_LOCK_NEEDED) == .SDL_SURFACE_LOCK_NEEDED);
	}

	public const c_char* SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT              = "SDL.surface.SDR_white_point";
	public const c_char* SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT                 = "SDL.surface.HDR_headroom";
	public const c_char* SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING            = "SDL.surface.tonemap";
	public const c_char* SDL_PROP_SURFACE_HOTSPOT_X_NUMBER                   = "SDL.surface.hotspot.x";
	public const c_char* SDL_PROP_SURFACE_HOTSPOT_Y_NUMBER                   = "SDL.surface.hotspot.y";


	[CLink] public static extern SDL_Surface* SDL_CreateSurface(c_int width, c_int height, SDL_PixelFormat format);

	[CLink] public static extern SDL_Surface* SDL_CreateSurfaceFrom(c_int width, c_int height, SDL_PixelFormat format, void* pixels, c_int pitch);

	[CLink] public static extern void SDL_DestroySurface(SDL_Surface* surface);

	[CLink] public static extern SDL_PropertiesID SDL_GetSurfaceProperties(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_SetSurfaceColorspace(SDL_Surface* surface, SDL_Colorspace colorspace);

	[CLink] public static extern SDL_Colorspace SDL_GetSurfaceColorspace(SDL_Surface* surface);

	[CLink] public static extern SDL_Palette* SDL_CreateSurfacePalette(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_SetSurfacePalette(SDL_Surface* surface, SDL_Palette* palette);

	[CLink] public static extern SDL_Palette* SDL_GetSurfacePalette(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_AddSurfaceAlternateImage(SDL_Surface* surface, SDL_Surface* image);

	[CLink] public static extern c_bool SDL_SurfaceHasAlternateImages(SDL_Surface* surface);

	[CLink] public static extern SDL_Surface** SDL_GetSurfaceImages(SDL_Surface* surface, c_int* count);

	[CLink] public static extern void SDL_RemoveSurfaceAlternateImages(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_LockSurface(SDL_Surface* surface);

	[CLink] public static extern void SDL_UnlockSurface(SDL_Surface* surface);

	[CLink] public static extern SDL_Surface* SDL_LoadBMP_IO(SDL_IOStream* src, c_bool closeio);

	[CLink] public static extern SDL_Surface* SDL_LoadBMP(c_char* file);

	[CLink] public static extern c_bool SDL_SaveBMP_IO(SDL_Surface* surface, SDL_IOStream* dst, c_bool closeio);

	[CLink] public static extern c_bool SDL_SaveBMP(SDL_Surface* surface, c_char* file);

	[CLink] public static extern c_bool SDL_SetSurfaceRLE(SDL_Surface* surface, c_bool enabled);

	[CLink] public static extern c_bool SDL_SurfaceHasRLE(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_SetSurfaceColorKey(SDL_Surface* surface, c_bool enabled, uint32 key);

	[CLink] public static extern c_bool SDL_SurfaceHasColorKey(SDL_Surface* surface);

	[CLink] public static extern c_bool SDL_GetSurfaceColorKey(SDL_Surface* surface, uint32* key);

	[CLink] public static extern c_bool SDL_SetSurfaceColorMod(SDL_Surface* surface, uint8 r, uint8 g, uint8 b);

	[CLink] public static extern c_bool SDL_GetSurfaceColorMod(SDL_Surface* surface, uint8* r, uint8* g, uint8* b);

	[CLink] public static extern c_bool SDL_SetSurfaceAlphaMod(SDL_Surface* surface, uint8 alpha);

	[CLink] public static extern c_bool SDL_GetSurfaceAlphaMod(SDL_Surface* surface, uint8* alpha);

	[CLink] public static extern c_bool SDL_SetSurfaceBlendMode(SDL_Surface* surface, SDL_BlendMode blendMode);

	[CLink] public static extern c_bool SDL_GetSurfaceBlendMode(SDL_Surface* surface, SDL_BlendMode* blendMode);

	[CLink] public static extern c_bool SDL_SetSurfaceClipRect(SDL_Surface* surface, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_GetSurfaceClipRect(SDL_Surface* surface, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_FlipSurface(SDL_Surface* surface, SDL_FlipMode flip);

	[CLink] public static extern SDL_Surface* SDL_DuplicateSurface(SDL_Surface* surface);

	[CLink] public static extern SDL_Surface* SDL_ScaleSurface(SDL_Surface* surface, c_int width, c_int height, SDL_ScaleMode scaleMode);

	[CLink] public static extern SDL_Surface* SDL_ConvertSurface(SDL_Surface* surface, SDL_PixelFormat format);

	[CLink] public static extern SDL_Surface* SDL_ConvertSurfaceAndColorspace(SDL_Surface* surface, SDL_PixelFormat format, SDL_Palette* palette, SDL_Colorspace colorspace, SDL_PropertiesID props);

	[CLink] public static extern c_bool SDL_ConvertPixels(c_int width, c_int height, SDL_PixelFormat src_format, void* src, c_int src_pitch, SDL_PixelFormat dst_format, void* dst, c_int dst_pitch);

	[CLink] public static extern c_bool SDL_ConvertPixelsAndColorspace(c_int width, c_int height, SDL_PixelFormat src_format, SDL_Colorspace src_colorspace, SDL_PropertiesID src_properties, void* src, c_int src_pitch, SDL_PixelFormat dst_format, SDL_Colorspace dst_colorspace, SDL_PropertiesID dst_properties, void* dst, c_int dst_pitch);

	[CLink] public static extern c_bool SDL_PremultiplyAlpha(c_int width, c_int height, SDL_PixelFormat src_format, void* src, c_int src_pitch, SDL_PixelFormat dst_format, void* dst, c_int dst_pitch, c_bool linear);

	[CLink] public static extern c_bool SDL_PremultiplySurfaceAlpha(SDL_Surface* surface, c_bool linear);

	[CLink] public static extern c_bool SDL_ClearSurface(SDL_Surface* surface, float r, float g, float b, float a);

	[CLink] public static extern c_bool SDL_FillSurfaceRect(SDL_Surface* dst, SDL_Rect* rect, uint32 color);

	[CLink] public static extern c_bool SDL_FillSurfaceRects(SDL_Surface* dst, SDL_Rect* rects, c_int count, uint32 color);

	[CLink] public static extern c_bool SDL_BlitSurface(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

	[CLink] public static extern c_bool SDL_BlitSurfaceUnchecked(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

	[CLink] public static extern c_bool SDL_BlitSurfaceScaled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode);

	[CLink] public static extern c_bool SDL_BlitSurfaceUncheckedScaled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode);

	[CLink] public static extern c_bool SDL_BlitSurfaceTiled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

	[CLink] public static extern c_bool SDL_BlitSurfaceTiledWithScale(SDL_Surface* src, SDL_Rect* srcrect, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, SDL_Rect* dstrect);

	[CLink] public static extern c_bool SDL_BlitSurface9Grid(SDL_Surface* src, SDL_Rect* srcrect, c_int left_width, c_int right_width, c_int top_height, c_int bottom_height, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, SDL_Rect* dstrect);

	[CLink] public static extern uint32 SDL_MapSurfaceRGB(SDL_Surface* surface, uint8 r, uint8 g, uint8 b);

	[CLink] public static extern uint32 SDL_MapSurfaceRGBA(SDL_Surface* surface, uint8 r, uint8 g, uint8 b, uint8 a);

	[CLink] public static extern c_bool SDL_ReadSurfacePixel(SDL_Surface* surface, c_int x, c_int y, uint8* r, uint8* g, uint8* b, uint8* a);

	[CLink] public static extern c_bool SDL_ReadSurfacePixelFloat(SDL_Surface* surface, c_int x, c_int y, float* r, float* g, float* b, float* a);

	[CLink] public static extern c_bool SDL_WriteSurfacePixel(SDL_Surface* surface, c_int x, c_int y, uint8 r, uint8 g, uint8 b, uint8 a);

	[CLink] public static extern c_bool SDL_WriteSurfacePixelFloat(SDL_Surface* surface, c_int x, c_int y, float r, float g, float b, float a);

	[CLink] public static extern c_bool SDL_StretchSurface(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode);

		 //SDL_system.h

	public typealias SDL_WindowsMessageHook = function c_bool(void* userdata, MSG* msg);

	public struct MSG;

	public typealias SDL_X11EventHook = function c_bool(void* userdata, XEvent* exevent);

	public struct XEvent;

	public enum SDL_Sandbox : c_int
	{
		SDL_SANDBOX_NONE = 0,
		SDL_SANDBOX_UNKNOWN_CONTAINER,
		SDL_SANDBOX_FLATPAK,
		SDL_SANDBOX_SNAP,
		SDL_SANDBOX_MACOS
	}

	[CLink] public static extern void SDL_SetWindowsMessageHook(SDL_WindowsMessageHook callback, void* userdata);

	[CLink] public static extern c_int SDL_GetDirect3D9AdapterIndex(SDL_DisplayID displayID);

	[CLink] public static extern c_bool SDL_GetDXGIOutputInfo(SDL_DisplayID displayID, c_int* adapterIndex, c_int* outputIndex);

	[CLink] public static extern void SDL_SetX11EventHook(SDL_X11EventHook callback, void* userdata);

	[CLink] public static extern c_bool SDL_SetLinuxThreadPriority(int64 threadID, c_int priority);

	[CLink] public static extern c_bool SDL_SetLinuxThreadPriorityAndPolicy(int64 threadID, c_int sdlPriority, c_int schedPolicy);

	[CLink] public static extern void SDL_SetiOSEventPump(c_bool enabled);

	[CLink] public static extern void*  SDL_GetAndroidJNIEnv();

	[CLink] public static extern void*  SDL_GetAndroidActivity();

	[CLink] public static extern c_int SDL_GetAndroidSDKVersion();

	[CLink] public static extern c_bool SDL_IsChromebook();

	[CLink] public static extern c_bool SDL_IsDeXMode();

	[CLink] public static extern void SDL_SendAndroidBackButton();

	[CLink] public static extern c_char*  SDL_GetAndroidInternalStoragePath();

	[CLink] public static extern uint32 SDL_GetAndroidExternalStorageState();

	[CLink] public static extern c_char*  SDL_GetAndroidExternalStoragePath();

	[CLink] public static extern c_char*  SDL_GetAndroidCachePath();

	[CLink] public static extern c_bool SDL_ShowAndroidToast(c_char* message, c_int duration, c_int gravity, c_int xoffset, c_int yoffset);

	[CLink] public static extern c_bool SDL_SendAndroidMessage(uint32 command, c_int param);

	[CLink] public static extern c_bool SDL_IsTablet();

	[CLink] public static extern c_bool SDL_IsTV();

	[CLink] public static extern SDL_Sandbox SDL_GetSandbox();

	[CLink] public static extern void SDL_OnApplicationWillTerminate();

	[CLink] public static extern void SDL_OnApplicationDidReceiveMemoryWarning();

	[CLink] public static extern void SDL_OnApplicationWillEnterBackground();

	[CLink] public static extern void SDL_OnApplicationDidEnterBackground();

	[CLink] public static extern void SDL_OnApplicationWillEnterForeground();

	[CLink] public static extern void SDL_OnApplicationDidEnterForeground();

	[CLink] public static extern void SDL_OnApplicationDidChangeStatusBarOrientation();


	//SDL_thread.h

	[CRepr]
	public struct SDL_Thread;

	public typealias SDL_ThreadID = uint64;

	public typealias SDL_ThreadFunction = function c_int(void* data);

	public enum SDL_ThreadPriority : c_int
	{
		SDL_THREAD_PRIORITY_LOW,
		SDL_THREAD_PRIORITY_NORMAL,
		SDL_THREAD_PRIORITY_HIGH,
		SDL_THREAD_PRIORITY_TIME_CRITICAL
	}

	public typealias SDL_TLSID = SDL_AtomicInt;

	public enum SDL_ThreadState : c_int
	{
		SDL_THREAD_UNKNOWN, /**< The thread is not valid */
		SDL_THREAD_ALIVE, /**< The thread is currently running */
		SDL_THREAD_DETACHED, /**< The thread is detached and can't be waited on */
		SDL_THREAD_COMPLETE /**< The thread has finished and should be cleaned up with SDL_WaitThread() */
	}

	public const c_char* SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER                  = "SDL.thread.create.entry_function";
	public const c_char* SDL_PROP_THREAD_CREATE_NAME_STRING                             = "SDL.thread.create.name";
	public const c_char* SDL_PROP_THREAD_CREATE_USERDATA_POINTER                        = "SDL.thread.create.userdata";
	public const c_char* SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER                        = "SDL.thread.create.stacksize";

	public typealias SDL_TLSDestructorCallback = function void(void* value);

	[CLink] public static extern SDL_Thread* SDL_CreateThread(SDL_ThreadFunction fn, c_char* name, void* data);

	[CLink] public static extern SDL_Thread* SDL_CreateThreadWithProperties(SDL_PropertiesID props);

	[CLink] public static extern SDL_Thread* SDL_CreateThreadRuntime(SDL_ThreadFunction fn, c_char* name, void* data, SDL_FunctionPointer pfnBeginThread, SDL_FunctionPointer pfnEndThread);

	[CLink] public static extern SDL_Thread* SDL_CreateThreadWithPropertiesRuntime(SDL_PropertiesID props, SDL_FunctionPointer pfnBeginThread, SDL_FunctionPointer pfnEndThread);

	[CLink] public static extern c_char* SDL_GetThreadName(SDL_Thread* thread);

	[CLink] public static extern SDL_ThreadID SDL_GetCurrentThreadID();

	[CLink] public static extern SDL_ThreadID SDL_GetThreadID(SDL_Thread* thread);

	[CLink] public static extern c_bool SDL_SetCurrentThreadPriority(SDL_ThreadPriority priority);

	[CLink] public static extern void SDL_WaitThread(SDL_Thread* thread, c_int* status);

	[CLink] public static extern void SDL_DetachThread(SDL_Thread* thread);

	[CLink] public static extern void* SDL_GetTLS(SDL_TLSID* id);

	[CLink] public static extern c_bool SDL_SetTLS(SDL_TLSID* id, void* value, SDL_TLSDestructorCallback destructor);

	[CLink] public static extern void SDL_CleanupTLS();

	//SDL_time.h

	public enum SDL_DateFormat : c_int
	{
		SDL_DATE_FORMAT_YYYYMMDD = 0, /**< Year/Month/Day */
		SDL_DATE_FORMAT_DDMMYYYY = 1, /**< Day/Month/Year */
		SDL_DATE_FORMAT_MMDDYYYY = 2 /**< Month/Day/Year */
	}

	public enum SDL_TimeFormat : c_int
	{
		SDL_TIME_FORMAT_24HR = 0, /**< 24 hour time */
		SDL_TIME_FORMAT_12HR = 1 /**< 12 hour time */
	}

	[CRepr]
	public struct SDL_DateTime
	{
		public c_int year; /**< Year */
		public c_int month; /**< Month [01-12] */
		public c_int day; /**< Day of the month [01-31] */
		public c_int hour; /**< Hour [0-23] */
		public c_int minute; /**< Minute [0-59] */
		public c_int second; /**< Seconds [0-60] */
		public c_int nanosecond; /**< Nanoseconds [0-999999999] */
		public c_int day_of_week; /**< Day of the week [0-6] (0 being Sunday) */
		public c_int utc_offset; /**< Seconds east of UTC */
	}

	[CLink] public static extern c_bool SDL_GetDateTimeLocalePreferences(SDL_DateFormat* dateFormat, SDL_TimeFormat* timeFormat);

	[CLink] public static extern c_bool SDL_GetCurrentTime(SDL_Time* ticks);

	[CLink] public static extern c_bool SDL_TimeToDateTime(SDL_Time ticks, SDL_DateTime* dt, c_bool localTime);

	[CLink] public static extern c_bool SDL_DateTimeToTime(SDL_DateTime* dt, SDL_Time* ticks);

	[CLink] public static extern void SDL_TimeToWindows(SDL_Time ticks, uint32* dwLowDateTime, uint32* dwHighDateTime);

	[CLink] public static extern SDL_Time SDL_TimeFromWindows(uint32 dwLowDateTime, uint32 dwHighDateTime);

	[CLink] public static extern c_int SDL_GetDaysInMonth(c_int year, c_int month);

	[CLink] public static extern c_int SDL_GetDayOfYear(c_int year, c_int month, c_int day);

	[CLink] public static extern c_int SDL_GetDayOfWeek(c_int year, c_int month, c_int day);

	//SDL_timer.h

	public typealias SDL_TimerID = uint32;

	public typealias SDL_TimerCallback = function uint32(void* userdata, SDL_TimerID timerID, uint32 interval);

	public typealias SDL_NSTimerCallback = function uint64(void* userdata, SDL_TimerID timerID, uint64 interval);

	public const uint64 SDL_MS_PER_SECOND  = 1000;

	public const uint64 SDL_US_PER_SECOND =  1000000;

	public const uint64 SDL_NS_PER_SECOND  = 1000000000L;

	public const uint64 SDL_NS_PER_MS   =    1000000;

	public const uint64 SDL_NS_PER_US  =     1000;

	public static uint64 SDL_SECONDS_TO_NS(uint64 S)  =>  (((uint64)(S)) * SDL_NS_PER_SECOND);

	public static uint64 SDL_NS_TO_SECONDS(uint64 NS)  => ((NS) / SDL_NS_PER_SECOND);

	public static uint64 SDL_MS_TO_NS(uint64 MS)   =>     (((uint64)(MS)) * SDL_NS_PER_MS);

	public static uint64 SDL_NS_TO_MS(uint64 NS)    =>    ((NS) / SDL_NS_PER_MS);

	public static uint64 SDL_US_TO_NS(uint64 US)      =>  (((uint64)(US)) * SDL_NS_PER_US);

	public static uint64 SDL_NS_TO_US(uint64 NS)    =>    ((NS) / SDL_NS_PER_US);

	[CLink] public static extern uint64 SDL_GetTicks();

	[CLink] public static extern uint64 SDL_GetTicksNS();

	[CLink] public static extern uint64 SDL_GetPerformanceCounter();

	[CLink] public static extern uint64 SDL_GetPerformanceFrequency();

	[CLink] public static extern void SDL_Delay(uint32 ms);

	[CLink] public static extern void SDL_DelayNS(uint64 ns);

	[CLink] public static extern void SDL_DelayPrecise(uint64 ns);

	[CLink] public static extern SDL_TimerID SDL_AddTimer(uint32 interval, SDL_TimerCallback callback, void* userdata);

	[CLink] public static extern SDL_TimerID SDL_AddTimerNS(uint64 interval, SDL_NSTimerCallback callback, void* userdata);

	[CLink] public static extern c_bool SDL_RemoveTimer(SDL_TimerID id);

	//SDL_touch.h

	public typealias SDL_TouchID = uint64;

	public enum SDL_TouchDeviceType : c_int
	{
		SDL_TOUCH_DEVICE_INVALID = -1,
		SDL_TOUCH_DEVICE_DIRECT, /* touch screen with window-relative coordinates */
		SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE, /* trackpad with absolute device coordinates */
		SDL_TOUCH_DEVICE_INDIRECT_RELATIVE /* trackpad with screen cursor-relative coordinates */
	}

	[CRepr]
	public struct SDL_Finger
	{
		public SDL_FingerID id; /**< the finger ID */
		public float x; /**< the x-axis location of the touch event, normalized (0...1) */
		public float y; /**< the y-axis location of the touch event, normalized (0...1) */
		public float pressure; /**< the quantity of pressure applied, normalized (0...1) */
	}

	public const uint32 SDL_TOUCH_MOUSEID = ((SDL_MouseID) - 1);

	public const uint64 SDL_MOUSE_TOUCHID = ((SDL_TouchID) - 1);

	public typealias SDL_FingerID = uint64;

	[CLink] public static extern SDL_TouchID* SDL_GetTouchDevices(c_int* count);

	[CLink] public static extern c_char* SDL_GetTouchDeviceName(SDL_TouchID touchID);

	[CLink] public static extern SDL_TouchDeviceType SDL_GetTouchDeviceType(SDL_TouchID touchID);

	[CLink] public static extern SDL_Finger** SDL_GetTouchFingers(SDL_TouchID touchID, c_int* count);

	//SDL_version.h

	[CLink] public static extern c_int SDL_GetVersion();

	[CLink] public static extern c_char* SDL_GetRevision();


	public const uint32 SDL_MAJOR_VERSION  = 3;

	public const uint32 SDL_MINOR_VERSION  = 2;

	public const uint32 SDL_MICRO_VERSION  = 14;

	public static uint32 SDL_VERSIONNUM(uint32 major, uint32 minor, uint32 patch) => ((major) * 1000000 + (minor) * 1000 + (patch));

	public static uint32 SDL_VERSIONNUM_MAJOR(uint32 version)  => ((version) / 1000000);

	public static uint32 SDL_VERSIONNUM_MINOR(uint32 version) => (((version) / 1000) % 1000);

	public static uint32 SDL_VERSIONNUM_MICRO(uint32 version) => ((version) % 1000);

	public const uint32 SDL_VERSION = SDL_VERSIONNUM(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION);

	public static c_bool SDL_VERSION_ATLEAST(uint32 X, uint32 Y, uint32 Z) => (SDL_VERSION >= SDL_VERSIONNUM(X, Y, Z));

	//SDL_tray.h

	public struct SDL_Tray;

	public struct SDL_TrayMenu;

	public struct SDL_TrayEntry;

	public enum SDL_TrayEntryFlags : uint32
	{
		SDL_TRAYENTRY_BUTTON      = 0x00000001, /**< Make the entry a simple button. Required. */
		SDL_TRAYENTRY_CHECKBOX    = 0x00000002, /**< Make the entry a checkbox. Required. */
		SDL_TRAYENTRY_SUBMENU     = 0x00000004, /**< Prepare the entry to have a submenu. Required */
		SDL_TRAYENTRY_DISABLED    = 0x80000000, /**< Make the entry disabled. Optional. */
		SDL_TRAYENTRY_CHECKED     = 0x40000000, /**< Make the entry checked. This is valid only for checkboxes. Optional. */
	}

	public typealias SDL_TrayCallback = function void(void* userdata, SDL_TrayEntry* entry);

	[CLink] public static extern SDL_Tray* SDL_CreateTray(SDL_Surface* icon, c_char* tooltip);

	[CLink] public static extern void SDL_SetTrayIcon(SDL_Tray* tray, SDL_Surface* icon);

	[CLink] public static extern void SDL_SetTrayTooltip(SDL_Tray* tray, c_char* tooltip);

	[CLink] public static extern SDL_TrayMenu* SDL_CreateTrayMenu(SDL_Tray* tray);

	[CLink] public static extern SDL_TrayMenu* SDL_CreateTraySubmenu(SDL_TrayEntry* entry);

	[CLink] public static extern SDL_TrayMenu* SDL_GetTrayMenu(SDL_Tray* tray);

	[CLink] public static extern SDL_TrayMenu* SDL_GetTraySubmenu(SDL_TrayEntry* entry);

	[CLink] public static extern SDL_TrayEntry** SDL_GetTrayEntries(SDL_TrayMenu* menu, c_int* count);

	[CLink] public static extern void SDL_RemoveTrayEntry(SDL_TrayEntry* entry);

	[CLink] public static extern SDL_TrayEntry* SDL_InsertTrayEntryAt(SDL_TrayMenu* menu, c_int pos, c_char* label, SDL_TrayEntryFlags flags);

	[CLink] public static extern void SDL_SetTrayEntryLabel(SDL_TrayEntry* entry, c_char* label);

	[CLink] public static extern c_char*  SDL_GetTrayEntryLabel(SDL_TrayEntry* entry);

	[CLink] public static extern void SDL_SetTrayEntryChecked(SDL_TrayEntry* entry, c_bool @checked);

	[CLink] public static extern c_bool SDL_GetTrayEntryChecked(SDL_TrayEntry* entry);

	[CLink] public static extern void SDL_SetTrayEntryEnabled(SDL_TrayEntry* entry, c_bool enabled);

	[CLink] public static extern c_bool SDL_GetTrayEntryEnabled(SDL_TrayEntry* entry);

	[CLink] public static extern void SDL_SetTrayEntryCallback(SDL_TrayEntry* entry, SDL_TrayCallback callback, void* userdata);

	[CLink] public static extern void SDL_ClickTrayEntry(SDL_TrayEntry* entry);

	[CLink] public static extern void SDL_DestroyTray(SDL_Tray* tray);

	[CLink] public static extern SDL_TrayMenu* SDL_GetTrayEntryParent(SDL_TrayEntry* entry);

	[CLink] public static extern SDL_TrayEntry* SDL_GetTrayMenuParentEntry(SDL_TrayMenu* menu);

	[CLink] public static extern SDL_Tray* SDL_GetTrayMenuParentTray(SDL_TrayMenu* menu);

	[CLink] public static extern void SDL_UpdateTrays();

	 //SDL_video.h

	public struct SDL_Window;

	public typealias SDL_EGLAttribArrayCallback = function SDL_EGLAttrib*(void* userdata);

	public typealias SDL_EGLAttrib = c_intptr;

	public typealias SDL_EGLIntArrayCallback = function SDL_EGLint*(void* userdata, SDL_EGLDisplay display, SDL_EGLConfig config);

	public typealias SDL_EGLint = c_int;

	public typealias SDL_EGLDisplay = void*;

	public typealias SDL_EGLConfig = void*;

	public typealias SDL_EGLSurface = void*;

	public enum SDL_GLattr : c_int
	{
		SDL_GL_RED_SIZE, /**< the minimum number of bits for the red channel of the color buffer; defaults to 8. */
		SDL_GL_GREEN_SIZE, /**< the minimum number of bits for the green channel of the color buffer; defaults to 8. */
		SDL_GL_BLUE_SIZE, /**< the minimum number of bits for the blue channel of the color buffer; defaults to 8. */
		SDL_GL_ALPHA_SIZE, /**< the minimum number of bits for the alpha channel of the color buffer; defaults to 8. */
		SDL_GL_BUFFER_SIZE, /**< the minimum number of bits for frame buffer size; defaults to 0. */
		SDL_GL_DOUBLEBUFFER, /**< whether the output is single or double buffered; defaults to double buffering on. */
		SDL_GL_DEPTH_SIZE, /**< the minimum number of bits in the depth buffer; defaults to 16. */
		SDL_GL_STENCIL_SIZE, /**< the minimum number of bits in the stencil buffer; defaults to 0. */
		SDL_GL_ACCUM_RED_SIZE, /**< the minimum number of bits for the red channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_GREEN_SIZE, /**< the minimum number of bits for the green channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_BLUE_SIZE, /**< the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_ALPHA_SIZE, /**< the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0. */
		SDL_GL_STEREO, /**< whether the output is stereo 3D; defaults to off. */
		SDL_GL_MULTISAMPLEBUFFERS, /**< the number of buffers used for multisample anti-aliasing; defaults to 0. */
		SDL_GL_MULTISAMPLESAMPLES, /**< the number of samples used around the current pixel used for multisample anti-aliasing. */
		SDL_GL_ACCELERATED_VISUAL, /**< set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either. */
		SDL_GL_RETAINED_BACKING, /**< not used (deprecated). */
		SDL_GL_CONTEXT_MAJOR_VERSION, /**< OpenGL context major version. */
		SDL_GL_CONTEXT_MINOR_VERSION, /**< OpenGL context minor version. */
		SDL_GL_CONTEXT_FLAGS, /**< some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0. */
		SDL_GL_CONTEXT_PROFILE_MASK, /**< type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform. */
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT, /**< OpenGL context sharing; defaults to 0. */
		SDL_GL_FRAMEBUFFER_SRGB_CAPABLE, /**< requests sRGB capable visual; defaults to 0. */
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR, /**< sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH. */
		SDL_GL_CONTEXT_RESET_NOTIFICATION, /**< set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION. */
		SDL_GL_CONTEXT_NO_ERROR,
		SDL_GL_FLOATBUFFERS,
		SDL_GL_EGL_PLATFORM
	}

	public enum SDL_FlashOperation : c_int
	{
		SDL_FLASH_CANCEL, /**< Cancel any window flash state */
		SDL_FLASH_BRIEFLY, /**< Flash the window briefly to get attention */
		SDL_FLASH_UNTIL_FOCUSED /**< Flash the window until it gets focus */
	}

	public enum SDL_WindowFlags : uint64
	{
		SDL_WINDOW_FULLSCREEN           = 0x0000000000000001, /**< window is in fullscreen mode */
		SDL_WINDOW_OPENGL               = 0x0000000000000002, /**< window usable with OpenGL context */
		SDL_WINDOW_OCCLUDED             = 0x0000000000000004, /**< window is occluded */
		SDL_WINDOW_HIDDEN               = 0x0000000000000008, /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible */
		SDL_WINDOW_BORDERLESS           = 0x0000000000000010, /**< no window decoration */
		SDL_WINDOW_RESIZABLE            = 0x0000000000000020, /**< window can be resized */
		SDL_WINDOW_MINIMIZED            = 0x0000000000000040, /**< window is minimized */
		SDL_WINDOW_MAXIMIZED            = 0x0000000000000080, /**< window is maximized */
		SDL_WINDOW_MOUSE_GRABBED        = 0x0000000000000100, /**< window has grabbed mouse input */
		SDL_WINDOW_INPUT_FOCUS          = 0x0000000000000200, /**< window has input focus */
		SDL_WINDOW_MOUSE_FOCUS          = 0x0000000000000400, /**< window has mouse focus */
		SDL_WINDOW_EXTERNAL             = 0x0000000000000800, /**< window not created by SDL */
		SDL_WINDOW_MODAL                = 0x0000000000001000, /**< window is modal */
		SDL_WINDOW_HIGH_PIXEL_DENSITY   = 0x0000000000002000, /**< window uses high pixel density back buffer if possible */
		SDL_WINDOW_MOUSE_CAPTURE        = 0x0000000000004000, /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
		SDL_WINDOW_MOUSE_RELATIVE_MODE  = 0x0000000000008000, /**< window has relative mode enabled */
		SDL_WINDOW_ALWAYS_ON_TOP        = 0x0000000000010000, /**< window should always be above others */
		SDL_WINDOW_UTILITY              = 0x0000000000020000, /**< window should be treated as a utility window, not showing in the task bar and window list */
		SDL_WINDOW_TOOLTIP              = 0x0000000000040000, /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
		SDL_WINDOW_POPUP_MENU           = 0x0000000000080000, /**< window should be treated as a popup menu, requires a parent window */
		SDL_WINDOW_KEYBOARD_GRABBED     = 0x0000000000100000, /**< window has grabbed keyboard input */
		SDL_WINDOW_VULKAN               = 0x0000000010000000, /**< window usable for Vulkan surface */
		SDL_WINDOW_METAL                = 0x0000000020000000, /**< window usable for Metal view */
		SDL_WINDOW_TRANSPARENT          = 0x0000000040000000, /**< window with transparent buffer */
		SDL_WINDOW_NOT_FOCUSABLE        = 0x0000000080000000 /**< window should not be focusable */
	}

	public typealias SDL_HitTest = function SDL_HitTestResult(SDL_Window* win, SDL_Point* area, void* data);

	public enum SDL_HitTestResult : c_int
	{
		SDL_HITTEST_NORMAL, /**< Region is normal. No special properties. */
		SDL_HITTEST_DRAGGABLE, /**< Region can drag entire window. */
		SDL_HITTEST_RESIZE_TOPLEFT, /**< Region is the resizable top-left corner border. */
		SDL_HITTEST_RESIZE_TOP, /**< Region is the resizable top border. */
		SDL_HITTEST_RESIZE_TOPRIGHT, /**< Region is the resizable top-right corner border. */
		SDL_HITTEST_RESIZE_RIGHT, /**< Region is the resizable right border. */
		SDL_HITTEST_RESIZE_BOTTOMRIGHT, /**< Region is the resizable bottom-right corner border. */
		SDL_HITTEST_RESIZE_BOTTOM, /**< Region is the resizable bottom border. */
		SDL_HITTEST_RESIZE_BOTTOMLEFT, /**< Region is the resizable bottom-left corner border. */
		SDL_HITTEST_RESIZE_LEFT /**< Region is the resizable left border. */
	}

	public typealias SDL_WindowID = uint32;

	[CRepr]
	public struct SDL_DisplayMode
	{
		public SDL_DisplayID displayID; /**< the display this mode is associated with */
		public SDL_PixelFormat format; /**< pixel format */
		public c_int w; /**< width */
		public c_int h; /**< height */
		public float pixel_density; /**< scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels) */
		public float refresh_rate; /**< refresh rate (or 0.0f for unspecified) */
		public c_int refresh_rate_numerator; /**< precise refresh rate numerator (or 0 for unspecified) */
		public c_int refresh_rate_denominator; /**< precise refresh rate denominator */

		public SDL_DisplayModeData* internal_; /**< Private */
	}

	public struct SDL_DisplayModeData;

	public typealias SDL_DisplayID = uint32;

	public enum SDL_DisplayOrientation : c_int
	{
		SDL_ORIENTATION_UNKNOWN, /**< The display orientation can't be determined */
		SDL_ORIENTATION_LANDSCAPE, /**< The display is in landscape mode, with the right side up, relative to portrait mode */
		SDL_ORIENTATION_LANDSCAPE_FLIPPED, /**< The display is in landscape mode, with the left side up, relative to portrait mode */
		SDL_ORIENTATION_PORTRAIT, /**< The display is in portrait mode */
		SDL_ORIENTATION_PORTRAIT_FLIPPED /**< The display is in portrait mode, upside down */
	}

	public enum SDL_SystemTheme : c_int
	{
		SDL_SYSTEM_THEME_UNKNOWN, /**< Unknown system theme */
		SDL_SYSTEM_THEME_LIGHT, /**< Light colored system theme */
		SDL_SYSTEM_THEME_DARK /**< Dark colored system theme */
	}

	public const c_char* SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN             = "SDL.display.HDR_enabled";
	public const c_char* SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER = "SDL.display.KMSDRM.panel_orientation";

	public const c_char* SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN               = "SDL.window.create.always_on_top";
	public const c_char* SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN                  = "SDL.window.create.borderless";
	public const c_char* SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN                   = "SDL.window.create.focusable";
	public const c_char* SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN   = "SDL.window.create.external_graphics_context";
	public const c_char* SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER                        = "SDL.window.create.flags";
	public const c_char* SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN                  = "SDL.window.create.fullscreen";
	public const c_char* SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER                       = "SDL.window.create.height";
	public const c_char* SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN                      = "SDL.window.create.hidden";
	public const c_char* SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN          = "SDL.window.create.high_pixel_density";
	public const c_char* SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN                   = "SDL.window.create.maximized";
	public const c_char* SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN                        = "SDL.window.create.menu";
	public const c_char* SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN                       = "SDL.window.create.metal";
	public const c_char* SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN                   = "SDL.window.create.minimized";
	public const c_char* SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN                       = "SDL.window.create.modal";
	public const c_char* SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN               = "SDL.window.create.mouse_grabbed";
	public const c_char* SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN                      = "SDL.window.create.opengl";
	public const c_char* SDL_PROP_WINDOW_CREATE_PARENT_POINTER                      = "SDL.window.create.parent";
	public const c_char* SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN                   = "SDL.window.create.resizable";
	public const c_char* SDL_PROP_WINDOW_CREATE_TITLE_STRING                        = "SDL.window.create.title";
	public const c_char* SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN                 = "SDL.window.create.transparent";
	public const c_char* SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN                     = "SDL.window.create.tooltip";
	public const c_char* SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN                     = "SDL.window.create.utility";
	public const c_char* SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN                      = "SDL.window.create.vulkan";
	public const c_char* SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER                        = "SDL.window.create.width";
	public const c_char* SDL_PROP_WINDOW_CREATE_X_NUMBER                            = "SDL.window.create.x";
	public const c_char* SDL_PROP_WINDOW_CREATE_Y_NUMBER                            = "SDL.window.create.y";
	public const c_char* SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER                = "SDL.window.create.cocoa.window";
	public const c_char* SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER                  = "SDL.window.create.cocoa.view";
	public const c_char* SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN = "SDL.window.create.wayland.surface_role_custom";
	public const c_char* SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN   = "SDL.window.create.wayland.create_egl_window";
	public const c_char* SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER          = "SDL.window.create.wayland.wl_surface";
	public const c_char* SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER                  = "SDL.window.create.win32.hwnd";
	public const c_char* SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER     = "SDL.window.create.win32.pixel_format_hwnd";
	public const c_char* SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER                   = "SDL.window.create.x11.window";

	public const c_char* SDL_PROP_WINDOW_SHAPE_POINTER                               = "SDL.window.shape";
	public const c_char* SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN                         = "SDL.window.HDR_enabled";
	public const c_char* SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT                       = "SDL.window.SDR_white_level";
	public const c_char* SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT                          = "SDL.window.HDR_headroom";
	public const c_char* SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER                      = "SDL.window.android.window";
	public const c_char* SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER                     = "SDL.window.android.surface";
	public const c_char* SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER                        = "SDL.window.uikit.window";
	public const c_char* SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER                 = "SDL.window.uikit.metal_view_tag";
	public const c_char* SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER             = "SDL.window.uikit.opengl.framebuffer";
	public const c_char* SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER            = "SDL.window.uikit.opengl.renderbuffer";
	public const c_char* SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER     = "SDL.window.uikit.opengl.resolve_framebuffer";
	public const c_char* SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER                  = "SDL.window.kmsdrm.dev_index";
	public const c_char* SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER                        = "SDL.window.kmsdrm.drm_fd";
	public const c_char* SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER                   = "SDL.window.kmsdrm.gbm_dev";
	public const c_char* SDL_PROP_WINDOW_COCOA_WINDOW_POINTER                        = "SDL.window.cocoa.window";
	public const c_char* SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER                 = "SDL.window.cocoa.metal_view_tag";
	public const c_char* SDL_PROP_WINDOW_OPENVR_OVERLAY_ID                           = "SDL.window.openvr.overlay_id";
	public const c_char* SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER                     = "SDL.window.vivante.display";
	public const c_char* SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER                      = "SDL.window.vivante.window";
	public const c_char* SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER                     = "SDL.window.vivante.surface";
	public const c_char* SDL_PROP_WINDOW_WIN32_HWND_POINTER                          = "SDL.window.win32.hwnd";
	public const c_char* SDL_PROP_WINDOW_WIN32_HDC_POINTER                           = "SDL.window.win32.hdc";
	public const c_char* SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER                      = "SDL.window.win32.instance";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER                     = "SDL.window.wayland.display";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER                     = "SDL.window.wayland.surface";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER                    = "SDL.window.wayland.viewport";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER                  = "SDL.window.wayland.egl_window";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER                 = "SDL.window.wayland.xdg_surface";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER                = "SDL.window.wayland.xdg_toplevel";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING   = "SDL.window.wayland.xdg_toplevel_export_handle";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER                   = "SDL.window.wayland.xdg_popup";
	public const c_char* SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER              = "SDL.window.wayland.xdg_positioner";
	public const c_char* SDL_PROP_WINDOW_X11_DISPLAY_POINTER                         = "SDL.window.x11.display";
	public const c_char* SDL_PROP_WINDOW_X11_SCREEN_NUMBER                           = "SDL.window.x11.screen";
	public const c_char* SDL_PROP_WINDOW_X11_WINDOW_NUMBER                           = "SDL.window.x11.window";
	public const uint32 SDL_WINDOW_SURFACE_VSYNC_DISABLED = 0;
	public const uint32 SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE  = uint32(-1);

	public const c_char* SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER = "SDL.video.wayland.wl_display";

	public const uint32 SDL_WINDOWPOS_UNDEFINED_MASK    = 0x1FFF0000;

	public static mixin SDL_WINDOWPOS_UNDEFINED_DISPLAY(SDL_DisplayID X)
	{
		(SDL_WINDOWPOS_UNDEFINED_MASK | (X))
	}

	public static mixin SDL_WINDOWPOS_UNDEFINED()
	{
		SDL_WINDOWPOS_UNDEFINED_DISPLAY!(0)
	}

	public static mixin SDL_WINDOWPOS_ISUNDEFINED(var X)
	{
		(((X) & 0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)
	}

	public const uint32 SDL_WINDOWPOS_CENTERED_MASK    = 0x2FFF0000;

	public static mixin SDL_WINDOWPOS_CENTERED_DISPLAY(SDL_DisplayID X)
	{
		(SDL_WINDOWPOS_CENTERED_MASK | (X))
	}

	public static mixin SDL_WINDOWPOS_CENTERED()
	{
		SDL_WINDOWPOS_CENTERED_DISPLAY!(0)
	}

	public static mixin SDL_WINDOWPOS_ISCENTERED(var X)
	{
		(((X) & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)
	}

	public struct SDL_GLContextState;

	public typealias SDL_GLContext =  SDL_GLContextState*;

	public enum SDL_GLAttr : c_int
	{
		SDL_GL_RED_SIZE, /**< the minimum number of bits for the red channel of the color buffer; defaults to 3. */
		SDL_GL_GREEN_SIZE, /**< the minimum number of bits for the green channel of the color buffer; defaults to 3. */
		SDL_GL_BLUE_SIZE, /**< the minimum number of bits for the blue channel of the color buffer; defaults to 2. */
		SDL_GL_ALPHA_SIZE, /**< the minimum number of bits for the alpha channel of the color buffer; defaults to 0. */
		SDL_GL_BUFFER_SIZE, /**< the minimum number of bits for frame buffer size; defaults to 0. */
		SDL_GL_DOUBLEBUFFER, /**< whether the output is single or double buffered; defaults to double buffering on. */
		SDL_GL_DEPTH_SIZE, /**< the minimum number of bits in the depth buffer; defaults to 16. */
		SDL_GL_STENCIL_SIZE, /**< the minimum number of bits in the stencil buffer; defaults to 0. */
		SDL_GL_ACCUM_RED_SIZE, /**< the minimum number of bits for the red channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_GREEN_SIZE, /**< the minimum number of bits for the green channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_BLUE_SIZE, /**< the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0. */
		SDL_GL_ACCUM_ALPHA_SIZE, /**< the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0. */
		SDL_GL_STEREO, /**< whether the output is stereo 3D; defaults to off. */
		SDL_GL_MULTISAMPLEBUFFERS, /**< the number of buffers used for multisample anti-aliasing; defaults to 0. */
		SDL_GL_MULTISAMPLESAMPLES, /**< the number of samples used around the current pixel used for multisample anti-aliasing. */
		SDL_GL_ACCELERATED_VISUAL, /**< set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either. */
		SDL_GL_RETAINED_BACKING, /**< not used (deprecated). */
		SDL_GL_CONTEXT_MAJOR_VERSION, /**< OpenGL context major version. */
		SDL_GL_CONTEXT_MINOR_VERSION, /**< OpenGL context minor version. */
		SDL_GL_CONTEXT_FLAGS, /**< some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0. */
		SDL_GL_CONTEXT_PROFILE_MASK, /**< type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform. */
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT, /**< OpenGL context sharing; defaults to 0. */
		SDL_GL_FRAMEBUFFER_SRGB_CAPABLE, /**< requests sRGB capable visual; defaults to 0. */
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR, /**< sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH. */
		SDL_GL_CONTEXT_RESET_NOTIFICATION, /**< set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION. */
		SDL_GL_CONTEXT_NO_ERROR,
		SDL_GL_FLOATBUFFERS,
		SDL_GL_EGL_PLATFORM
	}

	public enum SDL_GLProfile : uint32
	{
		SDL_GL_CONTEXT_PROFILE_CORE           = 0x0001, /**< OpenGL Core Profile context */
		SDL_GL_CONTEXT_PROFILE_COMPATIBILITY  = 0x0002, /**< OpenGL Compatibility Profile context */
		SDL_GL_CONTEXT_PROFILE_ES             = 0x0004, /**< GLX_CONTEXT_ES2_PROFILE_BIT_EXT */
	}

	public enum SDL_GLContextFlag : uint32
	{
		SDL_GL_CONTEXT_DEBUG_FLAG              = 0x0001,
		SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
		SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG      = 0x0004,
		SDL_GL_CONTEXT_RESET_ISOLATION_FLAG    = 0x0008,
	}

	public enum SDL_GLContextReleaseFlag : uint32
	{
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE   = 0x0000,
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH  = 0x0001,
	}

	public enum SDL_GLContextResetNotification : uint32
	{
		SDL_GL_CONTEXT_RESET_NO_NOTIFICATION  = 0x0000,
		SDL_GL_CONTEXT_RESET_LOSE_CONTEXT     = 0x0001,
	}

	[CLink] public static extern c_int SDL_GetNumVideoDrivers();

	[CLink] public static extern c_char*  SDL_GetVideoDriver(c_int index);

	[CLink] public static extern c_char*  SDL_GetCurrentVideoDriver();

	[CLink] public static extern SDL_SystemTheme SDL_GetSystemTheme();

	[CLink] public static extern SDL_DisplayID*  SDL_GetDisplays(c_int* count);

	[CLink] public static extern SDL_DisplayID SDL_GetPrimaryDisplay();

	[CLink] public static extern SDL_PropertiesID SDL_GetDisplayProperties(SDL_DisplayID displayID);

	[CLink] public static extern c_char*  SDL_GetDisplayName(SDL_DisplayID displayID);

	[CLink] public static extern c_bool SDL_GetDisplayBounds(SDL_DisplayID displayID, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_GetDisplayUsableBounds(SDL_DisplayID displayID, SDL_Rect* rect);

	[CLink] public static extern SDL_DisplayOrientation SDL_GetNaturalDisplayOrientation(SDL_DisplayID displayID);

	[CLink] public static extern SDL_DisplayOrientation SDL_GetCurrentDisplayOrientation(SDL_DisplayID displayID);

	[CLink] public static extern float SDL_GetDisplayContentScale(SDL_DisplayID displayID);

	[CLink] public static extern SDL_DisplayMode** SDL_GetFullscreenDisplayModes(SDL_DisplayID displayID, c_int* count);

	[CLink] public static extern c_bool SDL_GetClosestFullscreenDisplayMode(SDL_DisplayID displayID, c_int w, c_int h, float refresh_rate, c_bool include_high_density_modes, SDL_DisplayMode* mode);

	[CLink] public static extern SDL_DisplayMode* SDL_GetDesktopDisplayMode(SDL_DisplayID displayID);

	[CLink] public static extern SDL_DisplayMode* SDL_GetCurrentDisplayMode(SDL_DisplayID displayID);

	[CLink] public static extern SDL_DisplayID SDL_GetDisplayForPoint(SDL_Point* point);

	[CLink] public static extern SDL_DisplayID SDL_GetDisplayForRect(SDL_Rect* rect);

	[CLink] public static extern SDL_DisplayID SDL_GetDisplayForWindow(SDL_Window* window);

	[CLink] public static extern float SDL_GetWindowPixelDensity(SDL_Window* window);

	[CLink] public static extern float SDL_GetWindowDisplayScale(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowFullscreenMode(SDL_Window* window, SDL_DisplayMode* mode);

	[CLink] public static extern SDL_DisplayMode* SDL_GetWindowFullscreenMode(SDL_Window* window);

	[CLink] public static extern void* SDL_GetWindowICCProfile(SDL_Window* window, c_size* size);

	[CLink] public static extern SDL_PixelFormat SDL_GetWindowPixelFormat(SDL_Window* window);

	[CLink] public static extern SDL_Window**  DL_GetWindows(c_int* count);

	[CLink] public static extern SDL_Window* SDL_CreateWindow(c_char* title, c_int w, c_int h, SDL_WindowFlags flags);

	[CLink] public static extern SDL_Window* SDL_CreatePopupWindow(SDL_Window* parent, c_int offset_x, c_int offset_y, c_int w, c_int h, SDL_WindowFlags flags);

	[CLink] public static extern SDL_Window* SDL_CreateWindowWithProperties(SDL_PropertiesID props);

	[CLink] public static extern SDL_WindowID SDL_GetWindowID(SDL_Window* window);

	[CLink] public static extern SDL_Window*  SDL_GetWindowFromID(SDL_WindowID id);

	[CLink] public static extern SDL_Window*  SDL_GetWindowParent(SDL_Window* window);

	[CLink] public static extern SDL_PropertiesID SDL_GetWindowProperties(SDL_Window* window);

	[CLink] public static extern SDL_WindowFlags SDL_GetWindowFlags(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowTitle(SDL_Window* window, c_char* title);

	[CLink] public static extern c_char*  SDL_GetWindowTitle(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowIcon(SDL_Window* window, SDL_Surface* icon);

	[CLink] public static extern c_bool SDL_SetWindowPosition(SDL_Window* window, c_int x, c_int y);

	[CLink] public static extern c_bool SDL_GetWindowPosition(SDL_Window* window, c_int* x, c_int* y);

	[CLink] public static extern c_bool SDL_SetWindowSize(SDL_Window* window, c_int w, c_int h);

	[CLink] public static extern c_bool SDL_GetWindowSize(SDL_Window* window, c_int* w, c_int* h);

	[CLink] public static extern c_bool SDL_GetWindowSafeArea(SDL_Window* window, SDL_Rect* rect);

	[CLink] public static extern c_bool SDL_SetWindowAspectRatio(SDL_Window* window, float min_aspect, float max_aspect);

	[CLink] public static extern c_bool SDL_GetWindowAspectRatio(SDL_Window* window, float* min_aspect, float* max_aspect);

	[CLink] public static extern c_bool SDL_GetWindowBordersSize(SDL_Window* window, c_int* top, c_int* left, c_int* bottom, c_int* right);

	[CLink] public static extern c_bool SDL_GetWindowSizeInPixels(SDL_Window* window, c_int* w, c_int* h);

	[CLink] public static extern c_bool SDL_SetWindowMinimumSize(SDL_Window* window, c_int min_w, c_int min_h);

	[CLink] public static extern c_bool SDL_GetWindowMinimumSize(SDL_Window* window, c_int* w, c_int* h);

	[CLink] public static extern c_bool SDL_SetWindowMaximumSize(SDL_Window* window, c_int max_w, c_int max_h);

	[CLink] public static extern c_bool SDL_GetWindowMaximumSize(SDL_Window* window, c_int* w, c_int* h);

	[CLink] public static extern c_bool SDL_SetWindowBordered(SDL_Window* window, c_bool bordered);

	[CLink] public static extern c_bool SDL_SetWindowResizable(SDL_Window* window, c_bool resizable);

	[CLink] public static extern c_bool SDL_SetWindowAlwaysOnTop(SDL_Window* window, c_bool on_top);

	[CLink] public static extern c_bool SDL_ShowWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_HideWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_RaiseWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_MaximizeWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_MinimizeWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_RestoreWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowFullscreen(SDL_Window* window, c_bool fullscreen);

	[CLink] public static extern c_bool SDL_SyncWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_WindowHasSurface(SDL_Window* window);

	[CLink] public static extern SDL_Surface*  SDL_GetWindowSurface(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowSurfaceVSync(SDL_Window* window, c_int vsync);

	[CLink] public static extern c_bool SDL_GetWindowSurfaceVSync(SDL_Window* window, c_int* vsync);

	[CLink] public static extern c_bool SDL_UpdateWindowSurface(SDL_Window* window);

	[CLink] public static extern c_bool SDL_UpdateWindowSurfaceRects(SDL_Window* window, SDL_Rect* rects, c_int numrects);

	[CLink] public static extern c_bool SDL_DestroyWindowSurface(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowKeyboardGrab(SDL_Window* window, c_bool grabbed);

	[CLink] public static extern c_bool SDL_SetWindowMouseGrab(SDL_Window* window, c_bool grabbed);

	[CLink] public static extern c_bool SDL_GetWindowKeyboardGrab(SDL_Window* window);

	[CLink] public static extern c_bool SDL_GetWindowMouseGrab(SDL_Window* window);

	[CLink] public static extern SDL_Window*  SDL_GetGrabbedWindow();

	[CLink] public static extern c_bool SDL_SetWindowMouseRect(SDL_Window* window, SDL_Rect* rect);

	[CLink] public static extern SDL_Rect*  SDL_GetWindowMouseRect(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowOpacity(SDL_Window* window, float opacity);

	[CLink] public static extern float SDL_GetWindowOpacity(SDL_Window* window);

	[CLink] public static extern c_bool SDL_SetWindowParent(SDL_Window* window, SDL_Window* parent);

	[CLink] public static extern c_bool SDL_SetWindowModal(SDL_Window* window, c_bool modal);

	[CLink] public static extern c_bool SDL_SetWindowFocusable(SDL_Window* window, c_bool focusable);

	[CLink] public static extern c_bool SDL_ShowWindowSystemMenu(SDL_Window* window, c_int x, c_int y);

	[CLink] public static extern c_bool SDL_SetWindowHitTest(SDL_Window* window, SDL_HitTest callback, void* callback_data);

	[CLink] public static extern c_bool SDL_SetWindowShape(SDL_Window* window, SDL_Surface* shape);

	[CLink] public static extern c_bool SDL_FlashWindow(SDL_Window* window, SDL_FlashOperation operation);

	[CLink] public static extern void SDL_DestroyWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_ScreenSaverEnabled();

	[CLink] public static extern c_bool SDL_EnableScreenSaver();

	[CLink] public static extern c_bool SDL_DisableScreenSaver();

	[CLink] public static extern c_bool SDL_GL_LoadLibrary(c_char* path);

	[CLink] public static extern SDL_FunctionPointer SDL_GL_GetProcAddress(c_char* proc);

	[CLink] public static extern SDL_FunctionPointer SDL_EGL_GetProcAddress(c_char* proc);

	[CLink] public static extern void SDL_GL_UnloadLibrary();

	[CLink] public static extern c_bool SDL_GL_ExtensionSupported(c_char* extension_);

	[CLink] public static extern void SDL_GL_ResetAttributes();

	[CLink] public static extern c_bool SDL_GL_SetAttribute(SDL_GLattr attr, c_int value);

	[CLink] public static extern c_bool SDL_GL_GetAttribute(SDL_GLattr attr, c_int* value);

	[CLink] public static extern SDL_GLContext SDL_GL_CreateContext(SDL_Window* window);

	[CLink] public static extern c_bool SDL_GL_MakeCurrent(SDL_Window* window, SDL_GLContext context);

	[CLink] public static extern SDL_Window*  SDL_GL_GetCurrentWindow();

	[CLink] public static extern SDL_GLContext SDL_GL_GetCurrentContext();

	[CLink] public static extern SDL_EGLDisplay SDL_EGL_GetCurrentDisplay();

	[CLink] public static extern SDL_EGLConfig SDL_EGL_GetCurrentConfig();

	[CLink] public static extern SDL_EGLSurface SDL_EGL_GetWindowSurface(SDL_Window* window);

	[CLink] public static extern void SDL_EGL_SetAttributeCallbacks(SDL_EGLAttribArrayCallback platformAttribCallback, SDL_EGLIntArrayCallback surfaceAttribCallback, SDL_EGLIntArrayCallback contextAttribCallback, void* userdata);

	[CLink] public static extern c_bool SDL_GL_SetSwapInterval(c_int interval);

	[CLink] public static extern c_bool SDL_GL_GetSwapInterval(c_int* interval);

	[CLink] public static extern c_bool SDL_GL_SwapWindow(SDL_Window* window);

	[CLink] public static extern c_bool SDL_GL_DestroyContext(SDL_GLContext context);

	[CLink] public static extern c_bool SDL_GL_SetAttribute(SDL_GLAttr attr, c_int value);

	[CLink] public static extern c_bool SDL_GL_GetAttribute(SDL_GLAttr attr, c_int* value);

	[CLink] public static extern SDL_Window** SDL_GetWindows(int32* count);







	//SDL_vulkan.h

	[CRepr]
	public struct VkAllocationCallbacks
	{
		public void* pUserData;
		public PFN_vkAllocationFunction pfnAllocation;
		public PFN_vkReallocationFunction pfnReallocation;
		public PFN_vkFreeFunction pfnFree;
		public PFN_vkInternalAllocationNotification pfnInternalAllocation;
		public PFN_vkInternalFreeNotification pfnInternalFree;
	}

	public typealias PFN_vkAllocationFunction = function void*(void* pUserData, c_size size, c_size alignment, VkSystemAllocationScope allocationScope);

	public enum VkSystemAllocationScope : c_int
	{
		VK_SYSTEM_ALLOCATION_SCOPE_COMMAND = 0,
		VK_SYSTEM_ALLOCATION_SCOPE_OBJECT = 1,
		VK_SYSTEM_ALLOCATION_SCOPE_CACHE = 2,
		VK_SYSTEM_ALLOCATION_SCOPE_DEVICE = 3,
		VK_SYSTEM_ALLOCATION_SCOPE_INSTANCE = 4,
	}

	public typealias PFN_vkReallocationFunction = function void*(void* pUserData, void* pOriginal, c_size size, c_size alignment, VkSystemAllocationScope allocationScope);

	public typealias PFN_vkFreeFunction = function void(void* pUserData, void* pMemory);

	public typealias PFN_vkInternalAllocationNotification = function void(void* pUserData, c_size size, VkInternalAllocationType allocationType, VkSystemAllocationScope allocationScope);

	public typealias PFN_vkInternalFreeNotification = function void(void* pUserData, c_size size, VkInternalAllocationType allocationType, VkSystemAllocationScope alloctionScope);

	public enum VkInternalAllocationType : c_int
	{
		VK_INTERNAL_ALLOCATION_TYPE_EXECUTABLE = 0,
	}

	public struct VkInstance;

	public struct VkSurfaceKHR;

	public struct VkPhysicalDevice;

	[CLink] public static extern c_bool SDL_Vulkan_LoadLibrary(c_char* path);

	[CLink] public static extern SDL_FunctionPointer SDL_Vulkan_GetVkGetInstanceProcAddr();

	[CLink] public static extern void SDL_Vulkan_UnloadLibrary();

	[CLink] public static extern c_char**  SDL_Vulkan_GetInstanceExtensions(uint32* count);

	[CLink] public static extern c_bool SDL_Vulkan_CreateSurface(SDL_Window* window, VkInstance instance, VkAllocationCallbacks* allocator, VkSurfaceKHR* surface);

	[CLink] public static extern void SDL_Vulkan_DestroySurface(VkInstance instance, VkSurfaceKHR surface, VkAllocationCallbacks* allocator);

	[CLink] public static extern c_bool SDL_Vulkan_GetPresentationSupport(VkInstance instance, VkPhysicalDevice physicalDevice, uint32 queueFamilyIndex);

	//SDL_scancode.h

	public enum SDL_Scancode : c_int
	{
		SDL_SCANCODE_UNKNOWN = 0,

		SDL_SCANCODE_A = 4,
		SDL_SCANCODE_B = 5,
		SDL_SCANCODE_C = 6,
		SDL_SCANCODE_D = 7,
		SDL_SCANCODE_E = 8,
		SDL_SCANCODE_F = 9,
		SDL_SCANCODE_G = 10,
		SDL_SCANCODE_H = 11,
		SDL_SCANCODE_I = 12,
		SDL_SCANCODE_J = 13,
		SDL_SCANCODE_K = 14,
		SDL_SCANCODE_L = 15,
		SDL_SCANCODE_M = 16,
		SDL_SCANCODE_N = 17,
		SDL_SCANCODE_O = 18,
		SDL_SCANCODE_P = 19,
		SDL_SCANCODE_Q = 20,
		SDL_SCANCODE_R = 21,
		SDL_SCANCODE_S = 22,
		SDL_SCANCODE_T = 23,
		SDL_SCANCODE_U = 24,
		SDL_SCANCODE_V = 25,
		SDL_SCANCODE_W = 26,
		SDL_SCANCODE_X = 27,
		SDL_SCANCODE_Y = 28,
		SDL_SCANCODE_Z = 29,

		SDL_SCANCODE_1 = 30,
		SDL_SCANCODE_2 = 31,
		SDL_SCANCODE_3 = 32,
		SDL_SCANCODE_4 = 33,
		SDL_SCANCODE_5 = 34,
		SDL_SCANCODE_6 = 35,
		SDL_SCANCODE_7 = 36,
		SDL_SCANCODE_8 = 37,
		SDL_SCANCODE_9 = 38,
		SDL_SCANCODE_0 = 39,

		SDL_SCANCODE_RETURN = 40,
		SDL_SCANCODE_ESCAPE = 41,
		SDL_SCANCODE_BACKSPACE = 42,
		SDL_SCANCODE_TAB = 43,
		SDL_SCANCODE_SPACE = 44,

		SDL_SCANCODE_MINUS = 45,
		SDL_SCANCODE_EQUALS = 46,
		SDL_SCANCODE_LEFTBRACKET = 47,
		SDL_SCANCODE_RIGHTBRACKET = 48,
		SDL_SCANCODE_BACKSLASH = 49,
		SDL_SCANCODE_NONUSHASH = 50,
		SDL_SCANCODE_SEMICOLON = 51,
		SDL_SCANCODE_APOSTROPHE = 52,
		SDL_SCANCODE_GRAVE = 53,
		SDL_SCANCODE_COMMA = 54,
		SDL_SCANCODE_PERIOD = 55,
		SDL_SCANCODE_SLASH = 56,

		SDL_SCANCODE_CAPSLOCK = 57,

		SDL_SCANCODE_F1 = 58,
		SDL_SCANCODE_F2 = 59,
		SDL_SCANCODE_F3 = 60,
		SDL_SCANCODE_F4 = 61,
		SDL_SCANCODE_F5 = 62,
		SDL_SCANCODE_F6 = 63,
		SDL_SCANCODE_F7 = 64,
		SDL_SCANCODE_F8 = 65,
		SDL_SCANCODE_F9 = 66,
		SDL_SCANCODE_F10 = 67,
		SDL_SCANCODE_F11 = 68,
		SDL_SCANCODE_F12 = 69,

		SDL_SCANCODE_PRINTSCREEN = 70,
		SDL_SCANCODE_SCROLLLOCK = 71,
		SDL_SCANCODE_PAUSE = 72,
		SDL_SCANCODE_INSERT = 73,
		SDL_SCANCODE_HOME = 74,
		SDL_SCANCODE_PAGEUP = 75,
		SDL_SCANCODE_DELETE = 76,
		SDL_SCANCODE_END = 77,
		SDL_SCANCODE_PAGEDOWN = 78,
		SDL_SCANCODE_RIGHT = 79,
		SDL_SCANCODE_LEFT = 80,
		SDL_SCANCODE_DOWN = 81,
		SDL_SCANCODE_UP = 82,

		SDL_SCANCODE_NUMLOCKCLEAR = 83,
		SDL_SCANCODE_KP_DIVIDE = 84,
		SDL_SCANCODE_KP_MULTIPLY = 85,
		SDL_SCANCODE_KP_MINUS = 86,
		SDL_SCANCODE_KP_PLUS = 87,
		SDL_SCANCODE_KP_ENTER = 88,
		SDL_SCANCODE_KP_1 = 89,
		SDL_SCANCODE_KP_2 = 90,
		SDL_SCANCODE_KP_3 = 91,
		SDL_SCANCODE_KP_4 = 92,
		SDL_SCANCODE_KP_5 = 93,
		SDL_SCANCODE_KP_6 = 94,
		SDL_SCANCODE_KP_7 = 95,
		SDL_SCANCODE_KP_8 = 96,
		SDL_SCANCODE_KP_9 = 97,
		SDL_SCANCODE_KP_0 = 98,
		SDL_SCANCODE_KP_PERIOD = 99,

		SDL_SCANCODE_NONUSBACKSLASH = 100,
		SDL_SCANCODE_APPLICATION = 101,
		SDL_SCANCODE_POWER = 102,
		SDL_SCANCODE_KP_EQUALS = 103,
		SDL_SCANCODE_F13 = 104,
		SDL_SCANCODE_F14 = 105,
		SDL_SCANCODE_F15 = 106,
		SDL_SCANCODE_F16 = 107,
		SDL_SCANCODE_F17 = 108,
		SDL_SCANCODE_F18 = 109,
		SDL_SCANCODE_F19 = 110,
		SDL_SCANCODE_F20 = 111,
		SDL_SCANCODE_F21 = 112,
		SDL_SCANCODE_F22 = 113,
		SDL_SCANCODE_F23 = 114,
		SDL_SCANCODE_F24 = 115,
		SDL_SCANCODE_EXECUTE = 116,
		SDL_SCANCODE_HELP = 117, /**< AL Integrated Help Center */
		SDL_SCANCODE_MENU = 118, /**< Menu (show menu) */
		SDL_SCANCODE_SELECT = 119,
		SDL_SCANCODE_STOP = 120, /**< AC Stop */
		SDL_SCANCODE_AGAIN = 121, /**< AC Redo/Repeat */
		SDL_SCANCODE_UNDO = 122, /**< AC Undo */
		SDL_SCANCODE_CUT = 123, /**< AC Cut */
		SDL_SCANCODE_COPY = 124, /**< AC Copy */
		SDL_SCANCODE_PASTE = 125, /**< AC Paste */
		SDL_SCANCODE_FIND = 126, /**< AC Find */
		SDL_SCANCODE_MUTE = 127,
		SDL_SCANCODE_VOLUMEUP = 128,
		SDL_SCANCODE_VOLUMEDOWN = 129,
	/* not sure whether there's a reason to enable these */
	/*     SDL_SCANCODE_LOCKINGCAPSLOCK = 130,  */
	/*     SDL_SCANCODE_LOCKINGNUMLOCK = 131, */
	/*     SDL_SCANCODE_LOCKINGSCROLLLOCK = 132, */
		SDL_SCANCODE_KP_COMMA = 133,
		SDL_SCANCODE_KP_EQUALSAS400 = 134,

		SDL_SCANCODE_INTERNATIONAL1 = 135, /**< used on Asian keyboards, see
	footnotes in USB doc */
		SDL_SCANCODE_INTERNATIONAL2 = 136,
		SDL_SCANCODE_INTERNATIONAL3 = 137, /**< Yen */
		SDL_SCANCODE_INTERNATIONAL4 = 138,
		SDL_SCANCODE_INTERNATIONAL5 = 139,
		SDL_SCANCODE_INTERNATIONAL6 = 140,
		SDL_SCANCODE_INTERNATIONAL7 = 141,
		SDL_SCANCODE_INTERNATIONAL8 = 142,
		SDL_SCANCODE_INTERNATIONAL9 = 143,
		SDL_SCANCODE_LANG1 = 144, /**< Hangul/English toggle */
		SDL_SCANCODE_LANG2 = 145, /**< Hanja conversion */
		SDL_SCANCODE_LANG3 = 146, /**< Katakana */
		SDL_SCANCODE_LANG4 = 147, /**< Hiragana */
		SDL_SCANCODE_LANG5 = 148, /**< Zenkaku/Hankaku */
		SDL_SCANCODE_LANG6 = 149, /**< reserved */
		SDL_SCANCODE_LANG7 = 150, /**< reserved */
		SDL_SCANCODE_LANG8 = 151, /**< reserved */
		SDL_SCANCODE_LANG9 = 152, /**< reserved */

		SDL_SCANCODE_ALTERASE = 153, /**< Erase-Eaze */
		SDL_SCANCODE_SYSREQ = 154,
		SDL_SCANCODE_CANCEL = 155, /**< AC Cancel */
		SDL_SCANCODE_CLEAR = 156,
		SDL_SCANCODE_PRIOR = 157,
		SDL_SCANCODE_RETURN2 = 158,
		SDL_SCANCODE_SEPARATOR = 159,
		SDL_SCANCODE_OUT = 160,
		SDL_SCANCODE_OPER = 161,
		SDL_SCANCODE_CLEARAGAIN = 162,
		SDL_SCANCODE_CRSEL = 163,
		SDL_SCANCODE_EXSEL = 164,

		SDL_SCANCODE_KP_00 = 176,
		SDL_SCANCODE_KP_000 = 177,
		SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
		SDL_SCANCODE_DECIMALSEPARATOR = 179,
		SDL_SCANCODE_CURRENCYUNIT = 180,
		SDL_SCANCODE_CURRENCYSUBUNIT = 181,
		SDL_SCANCODE_KP_LEFTPAREN = 182,
		SDL_SCANCODE_KP_RIGHTPAREN = 183,
		SDL_SCANCODE_KP_LEFTBRACE = 184,
		SDL_SCANCODE_KP_RIGHTBRACE = 185,
		SDL_SCANCODE_KP_TAB = 186,
		SDL_SCANCODE_KP_BACKSPACE = 187,
		SDL_SCANCODE_KP_A = 188,
		SDL_SCANCODE_KP_B = 189,
		SDL_SCANCODE_KP_C = 190,
		SDL_SCANCODE_KP_D = 191,
		SDL_SCANCODE_KP_E = 192,
		SDL_SCANCODE_KP_F = 193,
		SDL_SCANCODE_KP_XOR = 194,
		SDL_SCANCODE_KP_POWER = 195,
		SDL_SCANCODE_KP_PERCENT = 196,
		SDL_SCANCODE_KP_LESS = 197,
		SDL_SCANCODE_KP_GREATER = 198,
		SDL_SCANCODE_KP_AMPERSAND = 199,
		SDL_SCANCODE_KP_DBLAMPERSAND = 200,
		SDL_SCANCODE_KP_VERTICALBAR = 201,
		SDL_SCANCODE_KP_DBLVERTICALBAR = 202,
		SDL_SCANCODE_KP_COLON = 203,
		SDL_SCANCODE_KP_HASH = 204,
		SDL_SCANCODE_KP_SPACE = 205,
		SDL_SCANCODE_KP_AT = 206,
		SDL_SCANCODE_KP_EXCLAM = 207,
		SDL_SCANCODE_KP_MEMSTORE = 208,
		SDL_SCANCODE_KP_MEMRECALL = 209,
		SDL_SCANCODE_KP_MEMCLEAR = 210,
		SDL_SCANCODE_KP_MEMADD = 211,
		SDL_SCANCODE_KP_MEMSUBTRACT = 212,
		SDL_SCANCODE_KP_MEMMULTIPLY = 213,
		SDL_SCANCODE_KP_MEMDIVIDE = 214,
		SDL_SCANCODE_KP_PLUSMINUS = 215,
		SDL_SCANCODE_KP_CLEAR = 216,
		SDL_SCANCODE_KP_CLEARENTRY = 217,
		SDL_SCANCODE_KP_BINARY = 218,
		SDL_SCANCODE_KP_OCTAL = 219,
		SDL_SCANCODE_KP_DECIMAL = 220,
		SDL_SCANCODE_KP_HEXADECIMAL = 221,

		SDL_SCANCODE_LCTRL = 224,
		SDL_SCANCODE_LSHIFT = 225,
		SDL_SCANCODE_LALT = 226, /**< alt, option */
		SDL_SCANCODE_LGUI = 227, /**< windows, command (apple), meta */
		SDL_SCANCODE_RCTRL = 228,
		SDL_SCANCODE_RSHIFT = 229,
		SDL_SCANCODE_RALT = 230, /**< alt gr, option */
		SDL_SCANCODE_RGUI = 231, /**< windows, command (apple), meta */

		SDL_SCANCODE_MODE = 257,
		SDL_SCANCODE_SLEEP = 258, /**< Sleep */
		SDL_SCANCODE_WAKE = 259, /**< Wake */

		SDL_SCANCODE_CHANNEL_INCREMENT = 260, /**< Channel Increment */
		SDL_SCANCODE_CHANNEL_DECREMENT = 261, /**< Channel Decrement */

		SDL_SCANCODE_MEDIA_PLAY = 262, /**< Play */
		SDL_SCANCODE_MEDIA_PAUSE = 263, /**< Pause */
		SDL_SCANCODE_MEDIA_RECORD = 264, /**< Record */
		SDL_SCANCODE_MEDIA_FAST_FORWARD = 265, /**< Fast Forward */
		SDL_SCANCODE_MEDIA_REWIND = 266, /**< Rewind */
		SDL_SCANCODE_MEDIA_NEXT_TRACK = 267, /**< Next Track */
		SDL_SCANCODE_MEDIA_PREVIOUS_TRACK = 268, /**< Previous Track */
		SDL_SCANCODE_MEDIA_STOP = 269, /**< Stop */
		SDL_SCANCODE_MEDIA_EJECT = 270, /**< Eject */
		SDL_SCANCODE_MEDIA_PLAY_PAUSE = 271, /**< Play / Pause */
		SDL_SCANCODE_MEDIA_SELECT = 272, /* Media Select */

		SDL_SCANCODE_AC_NEW = 273, /**< AC New */
		SDL_SCANCODE_AC_OPEN = 274, /**< AC Open */
		SDL_SCANCODE_AC_CLOSE = 275, /**< AC Close */
		SDL_SCANCODE_AC_EXIT = 276, /**< AC Exit */
		SDL_SCANCODE_AC_SAVE = 277, /**< AC Save */
		SDL_SCANCODE_AC_PRINT = 278, /**< AC Print */
		SDL_SCANCODE_AC_PROPERTIES = 279, /**< AC Properties */

		SDL_SCANCODE_AC_SEARCH = 280, /**< AC Search */
		SDL_SCANCODE_AC_HOME = 281, /**< AC Home */
		SDL_SCANCODE_AC_BACK = 282, /**< AC Back */
		SDL_SCANCODE_AC_FORWARD = 283, /**< AC Forward */
		SDL_SCANCODE_AC_STOP = 284, /**< AC Stop */
		SDL_SCANCODE_AC_REFRESH = 285, /**< AC Refresh */
		SDL_SCANCODE_AC_BOOKMARKS = 286, /**< AC Bookmarks */

	/* @} */ /* Usage page 0x0C */


	/* @{ */

		SDL_SCANCODE_SOFTLEFT = 287, /**< Usually situated below the display on phones and
										  used as a multi-function feature key for selecting
										  a software defined function shown on the bottom left
	of the display. */
		SDL_SCANCODE_SOFTRIGHT = 288, /**< Usually situated below the display on phones and
										   used as a multi-function feature key for selecting
										   a software defined function shown on the bottom right
	of the display. */
		SDL_SCANCODE_CALL = 289, /**< Used for accepting phone calls. */
		SDL_SCANCODE_ENDCALL = 290, /**< Used for rejecting phone calls. */

	/* @} */ /* Mobile keys */

	/* Add any other keys here. */

		SDL_SCANCODE_RESERVED = 400, /**< 400-500 reserved for dynamic keycodes */

		SDL_SCANCODE_COUNT = 512 /**< not a key, just marks the number of scancodes for array bounds */

	}

	//SDL_keycode.h

	public static SDL_Keycode SDL_Scancode_To_Keycode(SDL_Scancode scancode) => (.)(scancode | (.)(1u << 30));

	public enum SDL_Keycode : uint32
	{
		SDLK_UNKNOWN                = 0x00000000u, /**< 0 */
		SDLK_RETURN                 = 0x0000000du, /**< '\r' */
		SDLK_ESCAPE                 = 0x0000001bu, /**< '\x1B' */
		SDLK_BACKSPACE              = 0x00000008u, /**< '\b' */
		SDLK_TAB                    = 0x00000009u, /**< '\t' */
		SDLK_SPACE                  = 0x00000020u, /**< ' ' */
		SDLK_EXCLAIM                = 0x00000021u, /**< '!' */
		SDLK_DBLAPOSTROPHE          = 0x00000022u, /**< '"' */
		SDLK_HASH                   = 0x00000023u, /**< '#' */
		SDLK_DOLLAR                 = 0x00000024u, /**< '$' */
		SDLK_PERCENT                = 0x00000025u, /**< '%' */
		SDLK_AMPERSAND              = 0x00000026u, /**< '&' */
		SDLK_APOSTROPHE             = 0x00000027u, /**< '\'' */
		SDLK_LEFTPAREN              = 0x00000028u, /**< '(' */
		SDLK_RIGHTPAREN             = 0x00000029u, /**< ')' */
		SDLK_ASTERISK               = 0x0000002au, /**< '*' */
		SDLK_PLUS                   = 0x0000002bu, /**< '+' */
		SDLK_COMMA                  = 0x0000002cu, /**< ',' */
		SDLK_MINUS                  = 0x0000002du, /**< '-' */
		SDLK_PERIOD                 = 0x0000002eu, /**< '.' */
		SDLK_SLASH                  = 0x0000002fu, /**< '/' */
		SDLK_0                      = 0x00000030u, /**< '0' */
		SDLK_1                      = 0x00000031u, /**< '1' */
		SDLK_2                      = 0x00000032u, /**< '2' */
		SDLK_3                      = 0x00000033u, /**< '3' */
		SDLK_4                      = 0x00000034u, /**< '4' */
		SDLK_5                      = 0x00000035u, /**< '5' */
		SDLK_6                      = 0x00000036u, /**< '6' */
		SDLK_7                      = 0x00000037u, /**< '7' */
		SDLK_8                      = 0x00000038u, /**< '8' */
		SDLK_9                      = 0x00000039u, /**< '9' */
		SDLK_COLON                  = 0x0000003au, /**< ':' */
		SDLK_SEMICOLON              = 0x0000003bu, /**< ';' */
		SDLK_LESS                   = 0x0000003cu, /**< '<' */
		SDLK_EQUALS                 = 0x0000003du, /**< '=' */
		SDLK_GREATER                = 0x0000003eu, /**< '>' */
		SDLK_QUESTION               = 0x0000003fu, /**< '?' */
		SDLK_AT                     = 0x00000040u, /**< '@' */
		SDLK_LEFTBRACKET            = 0x0000005bu, /**< '[' */
		SDLK_BACKSLASH              = 0x0000005cu, /**< '\\' */
		SDLK_RIGHTBRACKET           = 0x0000005du, /**< ']' */
		SDLK_CARET                  = 0x0000005eu, /**< '^' */
		SDLK_UNDERSCORE             = 0x0000005fu, /**< '_' */
		SDLK_GRAVE                  = 0x00000060u, /**< '`' */
		SDLK_A                      = 0x00000061u, /**< 'a' */
		SDLK_B                      = 0x00000062u, /**< 'b' */
		SDLK_C                      = 0x00000063u, /**< 'c' */
		SDLK_D                      = 0x00000064u, /**< 'd' */
		SDLK_E                      = 0x00000065u, /**< 'e' */
		SDLK_F                      = 0x00000066u, /**< 'f' */
		SDLK_G                      = 0x00000067u, /**< 'g' */
		SDLK_H                      = 0x00000068u, /**< 'h' */
		SDLK_I                      = 0x00000069u, /**< 'i' */
		SDLK_J                      = 0x0000006au, /**< 'j' */
		SDLK_K                      = 0x0000006bu, /**< 'k' */
		SDLK_L                      = 0x0000006cu, /**< 'l' */
		SDLK_M                      = 0x0000006du, /**< 'm' */
		SDLK_N                      = 0x0000006eu, /**< 'n' */
		SDLK_O                      = 0x0000006fu, /**< 'o' */
		SDLK_P                      = 0x00000070u, /**< 'p' */
		SDLK_Q                      = 0x00000071u, /**< 'q' */
		SDLK_R                      = 0x00000072u, /**< 'r' */
		SDLK_S                      = 0x00000073u, /**< 's' */
		SDLK_T                      = 0x00000074u, /**< 't' */
		SDLK_U                      = 0x00000075u, /**< 'u' */
		SDLK_V                      = 0x00000076u, /**< 'v' */
		SDLK_W                      = 0x00000077u, /**< 'w' */
		SDLK_X                      = 0x00000078u, /**< 'x' */
		SDLK_Y                      = 0x00000079u, /**< 'y' */
		SDLK_Z                      = 0x0000007au, /**< 'z' */
		SDLK_LEFTBRACE              = 0x0000007bu, /**< '{' */
		SDLK_PIPE                   = 0x0000007cu, /**< '|' */
		SDLK_RIGHTBRACE             = 0x0000007du, /**< '}' */
		SDLK_TILDE                  = 0x0000007eu, /**< '~' */
		SDLK_DELETE                 = 0x0000007fu, /**< '\x7F' */
		SDLK_PLUSMINUS              = 0x000000b1u, /**< '\xB1' */
		SDLK_CAPSLOCK               = 0x40000039u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CAPSLOCK) */
		SDLK_F1                     = 0x4000003au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F1) */
		SDLK_F2                     = 0x4000003bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F2) */
		SDLK_F3                     = 0x4000003cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F3) */
		SDLK_F4                     = 0x4000003du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F4) */
		SDLK_F5                     = 0x4000003eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F5) */
		SDLK_F6                     = 0x4000003fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F6) */
		SDLK_F7                     = 0x40000040u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F7) */
		SDLK_F8                     = 0x40000041u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F8) */
		SDLK_F9                     = 0x40000042u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F9) */
		SDLK_F10                    = 0x40000043u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F10) */
		SDLK_F11                    = 0x40000044u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F11) */
		SDLK_F12                    = 0x40000045u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F12) */
		SDLK_PRINTSCREEN            = 0x40000046u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PRINTSCREEN) */
		SDLK_SCROLLLOCK             = 0x40000047u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SCROLLLOCK) */
		SDLK_PAUSE                  = 0x40000048u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAUSE) */
		SDLK_INSERT                 = 0x40000049u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_INSERT) */
		SDLK_HOME                   = 0x4000004au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_HOME) */
		SDLK_PAGEUP                 = 0x4000004bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAGEUP) */
		SDLK_END                    = 0x4000004du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_END) */
		SDLK_PAGEDOWN               = 0x4000004eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAGEDOWN) */
		SDLK_RIGHT                  = 0x4000004fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RIGHT) */
		SDLK_LEFT                   = 0x40000050u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LEFT) */
		SDLK_DOWN                   = 0x40000051u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DOWN) */
		SDLK_UP                     = 0x40000052u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_UP) */
		SDLK_NUMLOCKCLEAR           = 0x40000053u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_NUMLOCKCLEAR) */
		SDLK_KP_DIVIDE              = 0x40000054u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DIVIDE) */
		SDLK_KP_MULTIPLY            = 0x40000055u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MULTIPLY) */
		SDLK_KP_MINUS               = 0x40000056u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MINUS) */
		SDLK_KP_PLUS                = 0x40000057u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PLUS) */
		SDLK_KP_ENTER               = 0x40000058u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_ENTER) */
		SDLK_KP_1                   = 0x40000059u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_1) */
		SDLK_KP_2                   = 0x4000005au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_2) */
		SDLK_KP_3                   = 0x4000005bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_3) */
		SDLK_KP_4                   = 0x4000005cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_4) */
		SDLK_KP_5                   = 0x4000005du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_5) */
		SDLK_KP_6                   = 0x4000005eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_6) */
		SDLK_KP_7                   = 0x4000005fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_7) */
		SDLK_KP_8                   = 0x40000060u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_8) */
		SDLK_KP_9                   = 0x40000061u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_9) */
		SDLK_KP_0                   = 0x40000062u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_0) */
		SDLK_KP_PERIOD              = 0x40000063u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PERIOD) */
		SDLK_APPLICATION            = 0x40000065u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_APPLICATION) */
		SDLK_POWER                  = 0x40000066u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_POWER) */
		SDLK_KP_EQUALS              = 0x40000067u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EQUALS) */
		SDLK_F13                    = 0x40000068u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F13) */
		SDLK_F14                    = 0x40000069u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F14) */
		SDLK_F15                    = 0x4000006au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F15) */
		SDLK_F16                    = 0x4000006bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F16) */
		SDLK_F17                    = 0x4000006cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F17) */
		SDLK_F18                    = 0x4000006du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F18) */
		SDLK_F19                    = 0x4000006eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F19) */
		SDLK_F20                    = 0x4000006fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F20) */
		SDLK_F21                    = 0x40000070u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F21) */
		SDLK_F22                    = 0x40000071u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F22) */
		SDLK_F23                    = 0x40000072u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F23) */
		SDLK_F24                    = 0x40000073u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F24) */
		SDLK_EXECUTE                = 0x40000074u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_EXECUTE) */
		SDLK_HELP                   = 0x40000075u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_HELP) */
		SDLK_MENU                   = 0x40000076u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MENU) */
		SDLK_SELECT                 = 0x40000077u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SELECT) */
		SDLK_STOP                   = 0x40000078u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_STOP) */
		SDLK_AGAIN                  = 0x40000079u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AGAIN) */
		SDLK_UNDO                   = 0x4000007au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_UNDO) */
		SDLK_CUT                    = 0x4000007bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CUT) */
		SDLK_COPY                   = 0x4000007cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_COPY) */
		SDLK_PASTE                  = 0x4000007du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PASTE) */
		SDLK_FIND                   = 0x4000007eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_FIND) */
		SDLK_MUTE                   = 0x4000007fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MUTE) */
		SDLK_VOLUMEUP               = 0x40000080u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_VOLUMEUP) */
		SDLK_VOLUMEDOWN             = 0x40000081u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_VOLUMEDOWN) */
		SDLK_KP_COMMA               = 0x40000085u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_COMMA) */
		SDLK_KP_EQUALSAS400         = 0x40000086u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EQUALSAS400) */
		SDLK_ALTERASE               = 0x40000099u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_ALTERASE) */
		SDLK_SYSREQ                 = 0x4000009au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SYSREQ) */
		SDLK_CANCEL                 = 0x4000009bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CANCEL) */
		SDLK_CLEAR                  = 0x4000009cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CLEAR) */
		SDLK_PRIOR                  = 0x4000009du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PRIOR) */
		SDLK_RETURN2                = 0x4000009eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RETURN2) */
		SDLK_SEPARATOR              = 0x4000009fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SEPARATOR) */
		SDLK_OUT                    = 0x400000a0u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_OUT) */
		SDLK_OPER                   = 0x400000a1u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_OPER) */
		SDLK_CLEARAGAIN             = 0x400000a2u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CLEARAGAIN) */
		SDLK_CRSEL                  = 0x400000a3u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CRSEL) */
		SDLK_EXSEL                  = 0x400000a4u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_EXSEL) */
		SDLK_KP_00                  = 0x400000b0u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_00) */
		SDLK_KP_000                 = 0x400000b1u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_000) */
		SDLK_THOUSANDSSEPARATOR     = 0x400000b2u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_THOUSANDSSEPARATOR) */
		SDLK_DECIMALSEPARATOR       = 0x400000b3u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DECIMALSEPARATOR) */
		SDLK_CURRENCYUNIT           = 0x400000b4u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CURRENCYUNIT) */
		SDLK_CURRENCYSUBUNIT        = 0x400000b5u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CURRENCYSUBUNIT) */
		SDLK_KP_LEFTPAREN           = 0x400000b6u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LEFTPAREN) */
		SDLK_KP_RIGHTPAREN          = 0x400000b7u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_RIGHTPAREN) */
		SDLK_KP_LEFTBRACE           = 0x400000b8u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LEFTBRACE) */
		SDLK_KP_RIGHTBRACE          = 0x400000b9u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_RIGHTBRACE) */
		SDLK_KP_TAB                 = 0x400000bau, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_TAB) */
		SDLK_KP_BACKSPACE           = 0x400000bbu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_BACKSPACE) */
		SDLK_KP_A                   = 0x400000bcu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_A) */
		SDLK_KP_B                   = 0x400000bdu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_B) */
		SDLK_KP_C                   = 0x400000beu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_C) */
		SDLK_KP_D                   = 0x400000bfu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_D) */
		SDLK_KP_E                   = 0x400000c0u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_E) */
		SDLK_KP_F                   = 0x400000c1u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_F) */
		SDLK_KP_XOR                 = 0x400000c2u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_XOR) */
		SDLK_KP_POWER               = 0x400000c3u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_POWER) */
		SDLK_KP_PERCENT             = 0x400000c4u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PERCENT) */
		SDLK_KP_LESS                = 0x400000c5u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LESS) */
		SDLK_KP_GREATER             = 0x400000c6u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_GREATER) */
		SDLK_KP_AMPERSAND           = 0x400000c7u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_AMPERSAND) */
		SDLK_KP_DBLAMPERSAND        = 0x400000c8u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DBLAMPERSAND) */
		SDLK_KP_VERTICALBAR         = 0x400000c9u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_VERTICALBAR) */
		SDLK_KP_DBLVERTICALBAR      = 0x400000cau, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DBLVERTICALBAR) */
		SDLK_KP_COLON               = 0x400000cbu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_COLON) */
		SDLK_KP_HASH                = 0x400000ccu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_HASH) */
		SDLK_KP_SPACE               = 0x400000cdu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_SPACE) */
		SDLK_KP_AT                  = 0x400000ceu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_AT) */
		SDLK_KP_EXCLAM              = 0x400000cfu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EXCLAM) */
		SDLK_KP_MEMSTORE            = 0x400000d0u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMSTORE) */
		SDLK_KP_MEMRECALL           = 0x400000d1u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMRECALL) */
		SDLK_KP_MEMCLEAR            = 0x400000d2u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMCLEAR) */
		SDLK_KP_MEMADD              = 0x400000d3u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMADD) */
		SDLK_KP_MEMSUBTRACT         = 0x400000d4u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMSUBTRACT) */
		SDLK_KP_MEMMULTIPLY         = 0x400000d5u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMMULTIPLY) */
		SDLK_KP_MEMDIVIDE           = 0x400000d6u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMDIVIDE) */
		SDLK_KP_PLUSMINUS           = 0x400000d7u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PLUSMINUS) */
		SDLK_KP_CLEAR               = 0x400000d8u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_CLEAR) */
		SDLK_KP_CLEARENTRY          = 0x400000d9u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_CLEARENTRY) */
		SDLK_KP_BINARY              = 0x400000dau, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_BINARY) */
		SDLK_KP_OCTAL               = 0x400000dbu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_OCTAL) */
		SDLK_KP_DECIMAL             = 0x400000dcu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DECIMAL) */
		SDLK_KP_HEXADECIMAL         = 0x400000ddu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_HEXADECIMAL) */
		SDLK_LCTRL                  = 0x400000e0u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LCTRL) */
		SDLK_LSHIFT                 = 0x400000e1u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LSHIFT) */
		SDLK_LALT                   = 0x400000e2u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LALT) */
		SDLK_LGUI                   = 0x400000e3u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LGUI) */
		SDLK_RCTRL                  = 0x400000e4u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RCTRL) */
		SDLK_RSHIFT                 = 0x400000e5u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RSHIFT) */
		SDLK_RALT                   = 0x400000e6u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RALT) */
		SDLK_RGUI                   = 0x400000e7u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RGUI) */
		SDLK_MODE                   = 0x40000101u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MODE) */
		SDLK_SLEEP                  = 0x40000102u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SLEEP) */
		SDLK_WAKE                   = 0x40000103u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_WAKE) */
		SDLK_CHANNEL_INCREMENT      = 0x40000104u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CHANNEL_INCREMENT) */
		SDLK_CHANNEL_DECREMENT      = 0x40000105u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CHANNEL_DECREMENT) */
		SDLK_MEDIA_PLAY             = 0x40000106u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_PLAY) */
		SDLK_MEDIA_PAUSE            = 0x40000107u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_PAUSE) */
		SDLK_MEDIA_RECORD           = 0x40000108u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_RECORD) */
		SDLK_MEDIA_FAST_FORWARD     = 0x40000109u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_FAST_FORWARD) */
		SDLK_MEDIA_REWIND           = 0x4000010au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_REWIND) */
		SDLK_MEDIA_NEXT_TRACK       = 0x4000010bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_NEXT_TRACK) */
		SDLK_MEDIA_PREVIOUS_TRACK   = 0x4000010cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_PREVIOUS_TRACK) */
		SDLK_MEDIA_STOP             = 0x4000010du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_STOP) */
		SDLK_MEDIA_EJECT            = 0x4000010eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_EJECT) */
		SDLK_MEDIA_PLAY_PAUSE       = 0x4000010fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_PLAY_PAUSE) */
		SDLK_MEDIA_SELECT           = 0x40000110u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIA_SELECT) */
		SDLK_AC_NEW                 = 0x40000111u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_NEW) */
		SDLK_AC_OPEN                = 0x40000112u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_OPEN) */
		SDLK_AC_CLOSE               = 0x40000113u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_CLOSE) */
		SDLK_AC_EXIT                = 0x40000114u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_EXIT) */
		SDLK_AC_SAVE                = 0x40000115u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_SAVE) */
		SDLK_AC_PRINT               = 0x40000116u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_PRINT) */
		SDLK_AC_PROPERTIES          = 0x40000117u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_PROPERTIES) */
		SDLK_AC_SEARCH              = 0x40000118u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_SEARCH) */
		SDLK_AC_HOME                = 0x40000119u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_HOME) */
		SDLK_AC_BACK                = 0x4000011au, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_BACK) */
		SDLK_AC_FORWARD             = 0x4000011bu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_FORWARD) */
		SDLK_AC_STOP                = 0x4000011cu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_STOP) */
		SDLK_AC_REFRESH             = 0x4000011du, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_REFRESH) */
		SDLK_AC_BOOKMARKS           = 0x4000011eu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_BOOKMARKS) */
		SDLK_SOFTLEFT               = 0x4000011fu, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SOFTLEFT) */
		SDLK_SOFTRIGHT              = 0x40000120u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SOFTRIGHT) */
		SDLK_CALL                   = 0x40000121u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CALL) */
		SDLK_ENDCALL                = 0x40000122u, /**< SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_ENDCALL) */
	}

	public enum SDL_Keymod : uint16
	{
		SDL_KMOD_NONE   = 0x0000u, /**< no modifier is applicable. */
		SDL_KMOD_LSHIFT = 0x0001u, /**< the left Shift key is down. */
		SDL_KMOD_RSHIFT = 0x0002u, /**< the right Shift key is down. */
		SDL_KMOD_LCTRL  = 0x0040u, /**< the left Ctrl (Control) key is down. */
		SDL_KMOD_RCTRL  = 0x0080u, /**< the right Ctrl (Control) key is down. */
		SDL_KMOD_LALT   = 0x0100u, /**< the left Alt key is down. */
		SDL_KMOD_RALT   = 0x0200u, /**< the right Alt key is down. */
		SDL_KMOD_LGUI   = 0x0400u, /**< the left GUI key (often the Windows key) is down. */
		SDL_KMOD_RGUI   = 0x0800u, /**< the right GUI key (often the Windows key) is down. */
		SDL_KMOD_NUM    = 0x1000u, /**< the Num Lock key (may be located on an extended keypad) is down. */
		SDL_KMOD_CAPS   = 0x2000u, /**< the Caps Lock key is down. */
		SDL_KMOD_MODE   = 0x4000u, /**< the !AltGr key is down. */
		SDL_KMOD_SCROLL = 0x8000u, /**< the Scroll Lock key is down. */
		SDL_KMOD_CTRL   = (SDL_KMOD_LCTRL | SDL_KMOD_RCTRL), /**< Any Ctrl key is down. */
		SDL_KMOD_SHIFT  = (SDL_KMOD_LSHIFT | SDL_KMOD_RSHIFT), /**< Any Shift key is down. */
		SDL_KMOD_ALT    = (SDL_KMOD_LALT | SDL_KMOD_RALT), /**< Any Alt key is down. */
		SDL_KMOD_GUI    = (SDL_KMOD_LGUI | SDL_KMOD_RGUI), /**< Any GUI key is down. */
	}

	//SDL_pen.h

	public typealias SDL_PenID = uint32;

	public const uint32 SDL_PEN_MOUSEID = ((SDL_MouseID) - 2);

	public const uint64 SDL_PEN_TOUCHID = ((SDL_TouchID) - 2);

	public enum SDL_PenInputFlags : uint32
	{
		SDL_PEN_INPUT_DOWN       = (1u << 0), /**< pen is pressed down */
		SDL_PEN_INPUT_BUTTON_1   = (1u << 1), /**< button 1 is pressed */
		SDL_PEN_INPUT_BUTTON_2   = (1u << 2), /**< button 2 is pressed */
		SDL_PEN_INPUT_BUTTON_3   = (1u << 3), /**< button 3 is pressed */
		SDL_PEN_INPUT_BUTTON_4   = (1u << 4), /**< button 4 is pressed */
		SDL_PEN_INPUT_BUTTON_5   = (1u << 5), /**< button 5 is pressed */
		SDL_PEN_INPUT_ERASER_TIP = (1u << 30) /**< eraser tip is used */
	}

	public enum SDL_PenAxis : c_int
	{
		SDL_PEN_AXIS_PRESSURE, /**< Pen pressure.  Unidirectional: 0 to 1.0 */
		SDL_PEN_AXIS_XTILT, /**< Pen horizontal tilt angle.  Bidirectional: -90.0 to 90.0 (left-to-right). */
		SDL_PEN_AXIS_YTILT, /**< Pen vertical tilt angle.  Bidirectional: -90.0 to 90.0 (top-to-down). */
		SDL_PEN_AXIS_DISTANCE, /**< Pen distance to drawing surface.  Unidirectional: 0.0 to 1.0 */
		SDL_PEN_AXIS_ROTATION, /**< Pen barrel rotation.  Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down). */
		SDL_PEN_AXIS_SLIDER, /**< Pen finger wheel or slider (e.g., Airbrush Pen).  Unidirectional: 0 to 1.0 */
		SDL_PEN_AXIS_TANGENTIAL_PRESSURE, /**< Pressure from squeezing the pen ("barrel pressure"). */
		SDL_PEN_AXIS_COUNT /**< Total known pen axis types in this version of SDL. This number may grow in future releases! */
	}
}
