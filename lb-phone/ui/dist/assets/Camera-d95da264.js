import {
    r as n,
    j as o,
    F as _,
    a as b
} from "./jsx-runtime-f40812bf.js";
import {
    s as ge,
    R as he,
    w as pe,
    x as ve,
    f as i,
    u as Se,
    S as P,
    o as F,
    U as ee,
    d as f,
    V as be,
    b as j,
    C as L,
    W as ye,
    L as te,
    z as Ce,
    A as we,
    X as Pe,
    h as Re
} from "./Phone-1ddf01c8.js";
import {
    u as R,
    O as Ae,
    P as Ie,
    Q as ke
} from "./index.esm-e1f47206.js";
import {
    r as ae
} from "./number-28525126.js";

function Fe() {
    const d = R(Re),
        {
            Placement: re
        } = n.useContext(ge),
        ne = R(L.CameraComponent),
        M = R(P.Unlocked),
        H = R(P.PassedFaceId),
        V = R(P.Visible),
        se = R(P.LockScreenVisible),
        [Ne, A] = re.PhoneRotation,
        [z, y] = n.useState(!1),
        [c, E] = n.useState("Photo"),
        [O, X] = n.useState(!1),
        [oe, W] = n.useState(!1),
        [ie, $] = n.useState(!1),
        [h, G] = n.useState(!1),
        [u, ce] = n.useState(!1),
        [Q, q] = n.useState(0),
        [le, B] = n.useState({}),
        T = n.useRef(null),
        U = n.useRef(null),
        C = n.useRef(null),
        l = n.useRef(null),
        I = n.useRef(null),
        m = ["Video", "Photo", "Landscape"];
    n.useEffect(() => {
        if (!C.current || l.current) return;
        let e = new he(C.current);
        l.current = e
    }, [C.current, V]), n.useEffect(() => (pe("Camera").then(e => {
        e && (I.current = e)
    }), () => {
        l.current && l.current.destroy(), I.current && ve("Camera"), ne || i("Camera", {
            action: "close"
        })
    }), []), Se("camera:usedCommand", e => {
        switch (e) {
            case "toggleTaking":
                k();
                break;
            case "toggleFlip":
                G(t => !t);
                break;
            case "toggleFlash":
                X(t => !t);
                break;
            case "leftMode":
                if (u) return;
                E(t => {
                    const a = m.indexOf(t);
                    return a === 0 ? m[m.length - 1] : m[a - 1]
                });
                break;
            case "rightMode":
                if (u) return;
                E(t => {
                    const a = m.indexOf(t);
                    return a === m.length - 1 ? m[0] : m[a + 1]
                });
                break
        }
    }), n.useEffect(() => {
        if (!U.current) return;
        let e = [];
        const a = setInterval(() => {
            e.length > 2 && (e = []), e.push("."), U.current.innerText = te("APPS.CAMERA.UPLOADING") + e.join("")
        }, 500);
        return () => clearInterval(a)
    }, [z]);
    const x = (e, t) => {
        if (t === void 0 && (t = Ce(e)), t) {
            const a = document.createElement("video");
            a.src = e, a.muted = !0, a.play();
            const r = document.createElement("canvas");
            if (!r) return;
            a.addEventListener("loadeddata", () => {
                r.width = a.videoWidth, r.height = a.videoHeight, r.getContext("2d").drawImage(a, 0, 0, r.width, r.height);
                const p = r.toDataURL("image/png");
                T.current.style.backgroundImage = `url(${p})`, F.APPS.CAMERA.lastImage.set(p), r.remove(), a.remove()
            })
        } else T.current.style.backgroundImage = `url(${e})`, F.APPS.CAMERA.lastImage.set(e)
    };
    n.useEffect(() => {
        if (i("Camera", {
                action: V ? "open" : "close"
            }), se || !M) P.Flashlight && (i("toggleFlashlight", {
            toggled: !1
        }), P.Flashlight.set(!1)), A(0), E("Photo");
        else {
            if (i("Camera", {
                    action: "flipCamera",
                    value: h
                }), F.APPS.CAMERA.lastImage.value) return x(F.APPS.CAMERA.lastImage.value);
            i("Camera", {
                action: "getLastImage"
            }).then(e => {
                e && x(e)
            })
        }
    }, [M, H, V]), n.useEffect(() => {
        if (u) return;
        switch (c) {
            case "Landscape":
                B({
                    marginRight: "9rem"
                }), A(90);
                break;
            case "Video":
                A(0), B({
                    marginLeft: "12rem"
                });
                break;
            default:
                A(0), B({
                    marginLeft: "3rem"
                });
                break
        }
        c === "Landscape" ? l.current && l.current.resizeByAspect(16 / 9) : (c === "Video" || c === "Photo") && l.current && l.current.resizeByAspect(3 / 4), i("Camera", {
            action: "toggleLandscape",
            toggled: c === "Landscape"
        }), i("Camera", {
            action: "toggleVideo",
            toggled: c === "Video"
        });
        const e = window.innerWidth;
        e > 1920 && l.current.setQuality(1920 / e), c === "Photo" && h ? l.current.setXOffset(-.2) : l.current.setXOffset(0)
    }, [c]), n.useEffect(() => {
        i("Camera", {
            action: "flipCamera",
            value: h
        }), !u && (c == "Photo" && h ? l.current.setXOffset(-.2) : l.current.setXOffset(0))
    }, [M, h]);
    const K = n.useRef(!0),
        J = async (e, t) => {
            const a = ae(e.size / 1e3, 2);
            O && i("toggleFlashlight", {
                toggled: !1
            });
            try {
                const r = await we(t ? "Video" : "Image", e);
                return t ? x(URL.createObjectURL(e), !0) : x(r), f("info", `Saving ${t?"video":"photo"} to gallery (${a}kb) - ${r}, args(${r}, ${a}, ${h&&!t?"selfie":null})`), await Pe(r, a, h && !t ? "selfie" : null, !0), !0
            } catch (r) {
                throw r
            }
        };
    n.useEffect(() => {
        if (K.current) {
            K.current = !1;
            return
        }
        if (O && !u && i("toggleFlashlight", {
                toggled: !1
            }), !u) return;
        const e = C.current.captureStream(d.videoOptions.fps),
            t = new AudioContext,
            a = new MediaStreamAudioDestinationNode(t);
        I.current ? t.createMediaStreamSource(I.current).connect(a) : t.createOscillator().connect(a);
        let r;
        if (d.recordNearbyVoices) {
            r = d.ice ? new ee({
                config: {
                    iceTransportPolicy: "relay",
                    iceServers: d.ice
                }
            }) : new ee, r.on("open", g => {
                i("Camera", {
                    action: "setRecordingPeerId",
                    peerId: g
                }), f("info", "Listening for nearby voices")
            });
            const s = document.createElement("canvas");
            s.width = 1, s.height = 1;
            const S = s.captureStream(0);
            r.on("call", g => {
                g.answer(S), g.on("stream", w => {
                    f("info", "Received nearby voice");
                    const N = new Audio;
                    N.srcObject = w, N.volume = 0, N.play(), new MediaStreamAudioSourceNode(t, {
                        mediaStream: w
                    }).connect(a)
                }), g.on("close", () => {
                    f("info", "Stopped receiving nearby voice")
                })
            })
        }
        const p = [e.getVideoTracks()[0]];
        (I.current || d.recordNearbyVoices) && p.unshift(a.stream.getAudioTracks()[0]);
        const ue = new MediaStream(p),
            v = new MediaRecorder(ue, {
                mimeType: "video/webm;codecs=vp9,opus",
                videoBitsPerSecond: d.videoOptions.bitrate * 8 * 1e3
            });
        let D = 0;
        const fe = v.audioBitsPerSecond + v.videoBitsPerSecond,
            Y = setInterval(() => {
                const s = (Date.now() - D) / 1e3,
                    g = fe * s / 8 / 1024 / 1024,
                    w = ae(g, 2);
                w >= d.videoOptions.size && (f("info", `Video file size limit reached (${w}mb)`), clearInterval(Y), k())
            }, 100);
        let Z = [];
        v.ondataavailable = s => {
            var S;
            ((S = s == null ? void 0 : s.data) == null ? void 0 : S.size) > 0 && Z.push(s.data)
        }, v.onerror = s => {
            f("error", "error recording:", s)
        }, v.onstop = async () => {
            clearInterval(Y);
            let s = Date.now() - D,
                S = new Blob(Z, {
                    type: "video/webm"
                });
            t.close(), y(!0), r && (r.destroy(), f("info", "Destroyed peer connection"), i("Camera", {
                action: "endedRecording"
            }));
            const g = await be(S, s, {
                logger: !1
            });
            try {
                await J(g, !0), y(!1)
            } catch {
                y(!1), $(!0), await new Promise(N => setTimeout(N, 1e4)), $(!1)
            }
        }, D = Date.now(), v.start();
        const me = setInterval(() => {
            if (Q >= d.videoOptions.duration) return k();
            q(s => s + 1 >= d.videoOptions.duration ? (k(), 0) : s + 1)
        }, 1e3);
        return () => {
            q(0), clearInterval(me), v.stop()
        }
    }, [u]);
    const de = e => {
            let t = (e % 60).toString().padStart(2, "0"),
                a = (Math.floor(e / 60) % 60).toString().padStart(2, "0");
            return Math.floor(e / 3600).toString().padStart(2, "0") + ":" + a + ":" + t
        },
        k = async () => {
            var t, a;
            if (z) return f("info", "Returning since an image is currently uploading");
            if (O && await i("toggleFlashlight", {
                    toggled: !0
                }), c == "Video") {
                await i("Camera", {
                    action: "toggleHud",
                    toggled: u
                }), ce(r => !r);
                return
            }
            await i("Camera", {
                action: "toggleHud",
                toggled: !1
            }), (a = (t = j.Settings.value) == null ? void 0 : t.sound) != null && a.silent || j.SoundManager.set({
                url: "./assets/sound/other/cameraShutter.mp3"
            }), W(!0), L.IndicatorVisible.set(!1), y(!0), f("info", "Uploading image, converting to blob");
            const e = await new Promise(r => C.current.toBlob(r, d.imageOptions.mime, d.imageOptions.quality));
            try {
                await J(e, !1), f("info", "Image uploaded successfully"), y(!1), L.IndicatorVisible.set(!0)
            } catch {
                y(!1), $(!0), L.IndicatorVisible.set(!0), await new Promise(p => setTimeout(p, 1e4)), $(!1)
            }
            W(!1), await i("Camera", {
                action: "toggleHud",
                toggled: !0
            })
        };
    return o(_, {
        children: b("div", {
            className: "camera-container",
            children: [b("div", {
                className: "camera-header",
                children: [o("div", {
                    className: "flash",
                    onClick: () => X(e => !e),
                    children: !u && O ? o(Ae, {}) : o(Ie, {})
                }), c === "Video" && b(_, {
                    children: [o("div", {
                        className: "timer",
                        children: de(Q)
                    }), o("span", {})]
                })]
            }), b("div", {
                className: `camera-body ${c=="Landscape"?"rotate":""}`,
                children: [o("canvas", {
                    ref: C,
                    style: {
                        visibility: oe ? "hidden" : "visible"
                    }
                }), z && b("div", {
                    className: "loading",
                    children: [o(ye, {
                        size: 80,
                        speed: 1,
                        color: "#ffffff"
                    }), o("div", {
                        className: "uploading",
                        ref: U,
                        children: "Uploading..."
                    })]
                }), ie && o("div", {
                    className: "loading",
                    children: o("div", {
                        className: "uploading",
                        children: "Failed to upload, tell the server owner to check their API keys in lb-phone/server/apiKeys.lua"
                    })
                })]
            }), b("div", {
                className: "camera-bottom",
                children: [o("div", {
                    className: "camera-types",
                    style: le,
                    children: m.map((e, t) => o("div", {
                        className: `${c===e&&"active"}`,
                        onClick: () => E(e),
                        children: te(`APPS.CAMERA.${e.toUpperCase()}`)
                    }, t))
                }), b("div", {
                    className: "camera-buttons",
                    children: [o("div", {
                        className: "image-gallery",
                        ref: T,
                        onClick: () => {
                            !H && !M || (i("Camera", {
                                action: "close"
                            }), A(0), j.App.set({
                                name: "Photos"
                            }))
                        }
                    }), o("div", {
                        className: "camera-button",
                        onClick: () => k(),
                        children: o("div", {
                            className: "camera-button-container",
                            children: o("div", {
                                className: `camera-button-inner ${c=="Video"&&`${c} ${u==!0&&"Recording"}`}`
                            })
                        })
                    }), o("div", {
                        className: "flip-camera",
                        onClick: () => {
                            G(e => !e)
                        },
                        children: o(ke, {})
                    })]
                })]
            })]
        })
    })
}
export {
    Fe as
    default
};