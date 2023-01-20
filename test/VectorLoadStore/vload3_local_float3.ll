
; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t
; RUN: FileCheck %s < %t

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define void @foo(ptr addrspace(3) %in, i32 %offset) {
entry:
  %0 = call spir_func <3 x float> @_Z6vload3Dv3_jPU3AS3f(i32 %offset, ptr addrspace(3) %in)
  ret void
}

declare <3 x float> @_Z6vload3Dv3_jPU3AS3f(i32, ptr addrspace(3))

; CHECK: [[mul:%[a-zA-Z0-9_.]+]] = mul i32 %offset, 3
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 0
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr float, ptr addrspace(3) %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load float, ptr addrspace(3) [[gep]]
; CHECK: [[in0:%[a-zA-Z0-9_.]+]] = insertelement <3 x float> undef, float [[ld]], i64 0
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr float, ptr addrspace(3) %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load float, ptr addrspace(3) [[gep]]
; CHECK: [[in1:%[a-zA-Z0-9_.]+]] = insertelement <3 x float> [[in0]], float [[ld]], i64 1
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 2
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr float, ptr addrspace(3) %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load float, ptr addrspace(3) [[gep]]
; CHECK: [[in2:%[a-zA-Z0-9_.]+]] = insertelement <3 x float> [[in1]], float [[ld]], i64 2
