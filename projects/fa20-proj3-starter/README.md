- kernel maintains a variable ==brk== that points to the top of the heap
- An allocator maintains the heap as a collection of various-size blocks.
- Each block is a contiguous chunk of virtual memory that is either ==allocated== or ==free==
- Dynamic memory allocator such as ==malloc== can allocate or deallocate heap memory explicitly by using the ==mmap== and ==munmap== functions, or they can use the ==sbrk== function.

![image-20230703102204397](C:\Users\ming\AppData\Roaming\Typora\typora-user-images\image-20230703102204397.png)

Mila azul

159357
