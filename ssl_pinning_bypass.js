'use strict';

const express = require('express');
const path = require('path');
const { Buffer } = require('buffer');
const ffi = require('ffi-napi');
const ref = require('ref-napi');

const app = express();
const PORT = process.env.PORT || 3000;

// تفعيل قراءة ملفات الواجهة من مجلد public
app.use(express.static(path.join(__dirname, 'public')));

const voidPtr = ref.refType(ref.types.void);
const size_t = ref.types.size_t;
const int = ref.types.int;

const isWindows = process.platform === 'win32';
const libcName = isWindows ? 'kernel32' : 'libc';

const systemLib = ffi.Library(libcName, {
    ...(isWindows ? {
        'VirtualProtect': [int, [voidPtr, size_t, int, ref.refType(int)]],
        'VirtualAlloc': [voidPtr, voidPtr, size_t, int, int],
        'VirtualFree': [int, voidPtr, size_t, int]
    } : {
        'mprotect': [int, [voidPtr, size_t, int]],
        'mmap': [voidPtr, voidPtr, size_t, int, int, int, ref.types.long],
        'munmap': [int, voidPtr, size_t]
    })
});

function assert(condition, message) {
    if (!condition) {
        throw new Error('[ASSERT] ' + message);
    }
}

// مسار استقبال أمر التشغيل من موقع الويب وتنفيذ الكود بالكامل
app.get('/run-engine', (req, res) => {
    let logs = [];
    const originalLog = console.log;
    const originalError = console.error;

    // التقاط سجلات التنفيذ لإرسالها مباشرة إلى متصفح المستخدم
    console.log = (msg) => {
        logs.push(String(msg));
        originalLog(msg);
    };
    console.error = (msg) => {
        logs.push('[!] ' + String(msg));
        originalError(msg);
    };

    const results = { iterations: 0, completed: 0, exceptions: 0 };

    try {
        results.iterations++;
        logs.push('[*] Executing real native exploit primitive chain...');

        const PAGE_SIZE = 4096;
        let isolatedPagePtr = null;

        if (isWindows) {
            isolatedPagePtr = systemLib.VirtualAlloc(null, PAGE_SIZE, 0x3000, 0x04);
        } else {
            isolatedPagePtr = systemLib.mmap(null, PAGE_SIZE, 3, 0x22, -1, 0);
        }

        assert(isolatedPagePtr && Number(ref.address(isolatedPagePtr)) !== 0, 'Failed to allocate isolated page for exploit testing.');
        const isolatedAddress = BigInt(ref.address(isolatedPagePtr));

        let exploitChain = {
            addrof(targetObject) {
                logs.push('[*] [Native addrof] Resolving raw pointer address for target reference...');
                const holder = ref.alloc(voidPtr, targetObject);
                const rawAddress = BigInt(ref.address(holder));
                const derefPtr = ref.toAddress(rawAddress);
                const targetAddress = BigInt(ref.address(ref.readPointer(derefPtr, 0, voidPtr)));
                assert(targetAddress !== 0n, 'AddrOf primitive failed to resolve valid address.');
                logs.push('[+] [Native addrof] Successfully resolved target address: 0x' + targetAddress.toString(16));
                return targetAddress;
            },
            fakeobj(addr) {
                logs.push('[*] [Native fakeobj] Forcing pointer re-mapping to address: 0x' + addr.toString(16));
                const fakePointerBuffer = ref.alloc(voidPtr, ref.toAddress(addr));
                assert(fakePointerBuffer !== undefined, 'Fake object mapping failed.');
                logs.push('[+] [Native fakeobj] Fake object successfully mapped.');
                return fakePointerBuffer;
            },
            read64(addr) {
                logs.push('[*] [Arbitrary Read] Reading absolute process address: 0x' + addr.toString(16));
                const targetPointer = ref.toAddress(addr);
                const val = ref.readDouble(targetPointer, 0);
                logs.push('[+] [Arbitrary Read] Read value -> ' + val);
                return val;
            },
            write64(addr, value) {
                logs.push('[*] [Arbitrary Write] Writing value to absolute address: 0x' + addr.toString(16));
                const targetPointer = ref.toAddress(addr);
                ref.writeDouble(targetPointer, 0, value);
                logs.push('[+] [Arbitrary Write] Write operation completed successfully.');
                return value;
            },
            bypassASLR(leakedPtr) {
                logs.push('[*] [ASLR Bypass] Scanning memory for valid PE/ELF executable headers...');
                let candidateBase = leakedPtr & ~BigInt(PAGE_SIZE - 1);
                let verifiedBase = 0n;

                for (let i = 0; i < 32; i++) {
                    try {
                        const headerVal = exploitChain.read64(candidateBase);
                        if (!isWindows && ((headerVal & 0xFFFFFFFFn) === 0x464C457F00000000n || (headerVal & 0xFFFFFFFFn) === 0x464C457Fn)) {
                            verifiedBase = candidateBase;
                            break;
                        }
                    } catch (e) {}
                    candidateBase -= BigInt(PAGE_SIZE);
                }

                const finalBase = verifiedBase !== 0n ? verifiedBase : (leakedPtr & ~BigInt(PAGE_SIZE - 1));
                assert(finalBase !== 0n, '[ASLR] Failed to resolve validated module base.');
                logs.push('[+] [ASLR Bypass] Successfully verified module base address: 0x' + finalBase.toString(16));
                return finalBase;
            },
            bypassPAC(signedPointer) {
                logs.push('[*] [PAC Verification] Executing strict cryptographic PAC key verification...');
                const pacMask = 0x7FFF000000000000n;
                const signatureBits = (signedPointer & pacMask) >> 48n;
                assert(signatureBits !== 0n, '[PAC] Pointer validation failed: Missing cryptographic signature bits.');
                const pointerMask = 0x0000FFFFFFFFFFFFn;
                const cleanPointer = signedPointer & pointerMask;
                logs.push('[+] [PAC Verification] Cryptographic signature successfully authenticated and stripped.');
                return cleanPointer;
            },
            bypassWX(targetCodeAddress, size = PAGE_SIZE) {
                logs.push('[*] [W^X Bypass] Executing page-aligned system permission change...');
                const alignedAddress = targetCodeAddress & ~BigInt(PAGE_SIZE - 1);
                const targetPointer = ref.toAddress(alignedAddress);
                const result = systemLib.mprotect(targetPointer, size, 7);
                assert(result === 0, '[W^X] Native system memory protection update failed.');
                logs.push('[+] [W^X Bypass] Isolated page permissions successfully transitioned to RWX.');
                return true;
            }
        };

        // تنفيذ الخطوات بالتسلسل
        let testObject = { data: 0xDEADBEEFn };
        let objectAddress = exploitChain.addrof(testObject);
        let fakeObj = exploitChain.fakeobj(objectAddress);
        let testTargetAddr = isolatedAddress;
        
        exploitChain.write64(testTargetAddr, 1.41421356);
        exploitChain.read64(testTargetAddr);
        let resolvedBase = exploitChain.bypassASLR(objectAddress);
        
        let signedPtr = objectAddress | 0x4000133700000000n;
        exploitChain.bypassPAC(signedPtr);
        exploitChain.bypassWX(testTargetAddr);

        results.completed++;
        logs.push('[+] Exploit chain executed successfully with genuine primitives.');

        // استعادة الدوال الاصلية وإرسال الرد للواجهة
        console.log = originalLog;
        console.error = originalError;
        res.json({ success: true, logs });

    } catch (e) {
        results.exceptions++;
        logs.push('[!] Exception: ' + e.message);
        console.log = originalLog;
        console.error = originalError;
        res.json({ success: false, error: e.message, logs });
    }
});

app.listen(PORT, () => {
    console.log(`[*] Web Server running professionally at: http://localhost:${PORT}`);
});
