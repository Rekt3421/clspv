; RUN: clspv-opt --passes=specialize-image-types %s -o %t
; RUN: FileCheck %s < %t

; CHECK: define spir_kernel void @read_uint
; CHECK: call spir_func <4 x i32> @_Z12read_imageui27[[IMAGE:ocl_image3d_ro.uint.sampled]]11ocl_samplerDv4_f(ptr addrspace(1) %image
; CHECK: declare spir_func <4 x i32> @_Z12read_imageui27[[IMAGE]]11ocl_samplerDv4_f(ptr addrspace(1), ptr addrspace(2), <4 x float>) [[ATTRS:#[0-9]+]]
; CHECK: attributes [[ATTRS]] = { convergent nounwind }

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

%opencl.image3d_ro_t = type opaque
%opencl.sampler_t = type opaque

define spir_kernel void @read_uint(ptr addrspace(1) %image, <4 x float> %coord, ptr addrspace(1) nocapture %data) local_unnamed_addr #0 {
entry:
  %0 = tail call ptr addrspace(2) @__translate_sampler_initializer(i32 23) #2
  %call = tail call spir_func <4 x i32> @_Z12read_imageui14ocl_image3d_ro11ocl_samplerDv4_f(ptr addrspace(1) %image, ptr addrspace(2) %0, <4 x float> %coord) #3
  store <4 x i32> %call, ptr addrspace(1) %data, align 16
  ret void
}

declare spir_func <4 x i32> @_Z12read_imageui14ocl_image3d_ro11ocl_samplerDv4_f(ptr addrspace(1), ptr addrspace(2), <4 x float>) local_unnamed_addr #1

declare ptr addrspace(2) @__translate_sampler_initializer(i32) local_unnamed_addr

attributes #0 = { convergent }
attributes #1 = { convergent nounwind }
attributes #2 = { nounwind }
attributes #3 = { convergent nobuiltin nounwind readonly }

