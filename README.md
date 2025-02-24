# SDL3-Beef

![grafik](https://github.com/user-attachments/assets/1631c909-4b51-49b8-92d2-e0aa6414bb25)

This project is a binding for the SDL3 library to the Beef programming language.  
It provides one primary binding that aims to be as close as possible to the original library in the `SDL3.Raw` namespace.  
In the future a more Beef-like binding may be available in a different namespace.  
Currently it binds the `3.2.4` version of sdl

## Interface

### Raw
- Symbols are static global in the `SDL3.Raw` Namespace
- C uses defines for enums that arent 32bits. These have been translated into actual enums in Beef
- Some documentation for structs persists, but most of the code comments are removed
- `SDL_Scancode_To_Keycode` has been turned into a function since the macro doesnt work in Beef
- Some system specific functions have been commented out and marked with `TODO` as those take parameters that are platform dependent and not included in SDL3 itself
- Some Vulkan structs are also available to bind the vulkan header correctly
 
## License
SDL is licensed under the ZLib license.  
This binding is licensed under MIT

## Credit
Some parts of this binding where taken from: https://github.com/jayrulez/SDL3Native-Beef
