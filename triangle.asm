section .data
    window_title db "Triangle from NASM!", 0
    window_width  dd 800
    window_height dd 600
    
    align 16
    zero     dd 0.0
    one      dd 1.0
    half     dd 0.5
    neghalf  dd -0.5
    
    init_msg db "GLFW initialized", 10, 0
    window_msg db "Window created", 10, 0
    glew_msg db "GLEW initialized", 10, 0
    loop_msg db "Entering render loop", 10, 0
    frame_msg db "Frame rendered", 10, 0
    error_fmt db "GLFW Error %d: %s", 10, 0

section .bss
    window resq 1  

section .text
    global main
    extern glfwInit, glfwWindowHint, glfwCreateWindow, glfwMakeContextCurrent
    extern glewInit
    extern glClear, glBegin, glEnd, glFlush
    extern glClearColor, glVertex3f, glColor3f
    extern glfwSwapBuffers, glfwPollEvents, glfwWindowShouldClose
    extern glfwTerminate, glfwSetErrorCallback
    extern exit, printf, puts, sleep

error_callback:
    ; rdi = error code, rsi = description
    mov rdx, rsi      
    mov rsi, rdi      
    lea rdi, [rel error_fmt]  
    xor eax, eax    
    call printf
    ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32  
    
    lea rdi, [rel init_msg]
    call puts
    
    lea rdi, [rel error_callback]
    call glfwSetErrorCallback
    
    call glfwInit
    test eax, eax
    jz .fail

    lea rdi, [rel init_msg]
    call puts
    
    mov edi, dword [window_width]
    mov esi, dword [window_height]
    lea rdx, [window_title]
    xor rcx, rcx
    xor r8, r8
    call glfwCreateWindow
    test rax, rax
    jz .glfw_terminate
    
    mov [window], rax
    
    lea rdi, [rel window_msg]
    call puts
    
    mov rdi, [window]
    call glfwMakeContextCurrent

    call glewInit

    lea rdi, [rel glew_msg]
    call puts

    lea rdi, [rel loop_msg]
    call puts

.draw_loop:
    pxor xmm0, xmm0   ; R = 0
    pxor xmm1, xmm1   ; G = 0
    pxor xmm2, xmm2   ; B = 0
    movss xmm3, dword [one]  
    call glClearColor
    
    mov edi, 0x00004000  
    call glClear
    
    mov edi, 0x0004  ; GL_TRIANGLES
    call glBegin
    
    movss xmm0, dword [one]
    pxor xmm1, xmm1
    pxor xmm2, xmm2
    call glColor3f
    
    movss xmm0, dword [neghalf]
    movss xmm1, dword [neghalf]
    pxor xmm2, xmm2
    call glVertex3f
    
    pxor xmm0, xmm0
    movss xmm1, dword [one]
    pxor xmm2, xmm2
    call glColor3f
    
    movss xmm0, dword [half]
    movss xmm1, dword [neghalf]
    pxor xmm2, xmm2
    call glVertex3f
    
    pxor xmm0, xmm0
    pxor xmm1, xmm1
    movss xmm2, dword [one]
    call glColor3f
    
    pxor xmm0, xmm0
    movss xmm1, dword [half]
    pxor xmm2, xmm2
    call glVertex3f
    
    call glEnd
    call glFlush
    
    mov rdi, [window]
    call glfwSwapBuffers
    
    lea rdi, [rel frame_msg]
    call puts
    
    call glfwPollEvents
    
    mov rdi, [window]
    call glfwWindowShouldClose
    test eax, eax
    jz .draw_loop

.glfw_terminate:
    call glfwTerminate
    xor eax, eax
    jmp .exit

.fail:
    mov eax, 1

.exit:
    leave
    ret




