import {
    r as n,
    j as s,
    F as ee,
    a as S
} from "./jsx-runtime-f40812bf.js";
import {
    b as P,
    E as he,
    aC as ve,
    f as o,
    u as te,
    v as V,
    aD as ae,
    d as u,
    aE as pe,
    c as j,
    C as F,
    aF as Se,
    aG as be,
    aH as Ce,
    L as ne,
    aI as ye,
    W as Pe,
    a0 as Ie,
    aJ as Ae,
    h as ke,
    S as O
} from "./Phone-8f8bff8f.js";
import {
    r as re
} from "./number-28525126.js";

function Te() {
    const f = P(ke),
        {
            Placement: se
        } = n.useContext(he),
        oe = P(F.CameraComponent),
        N = P(O.Unlocked),
        H = P(O.PassedFaceId),
        x = P(O.Visible),
        ie = P(O.LockScreenVisible),
        [Re, I] = se.PhoneRotation,
        [$, b] = n.useState(!1),
        [c, E] = n.useState("Photo"),
        [M, G] = n.useState(!1),
        [ce, W] = n.useState(!1),
        [le, T] = n.useState(!1),
        [A, X] = n.useState(!1),
        [d, de] = n.useState(!1),
        [J, K] = n.useState(0),
        [ue, B] = n.useState({}),
        D = n.useRef(null),
        U = n.useRef(null),
        C = n.useRef(null),
        l = n.useRef(null),
        m = n.useRef(null),
        g = ["Video", "Photo", "Landscape"];
    n.useEffect(() => {
        if (!C.current || l.current) return;
        let e = new ve(C.current);
        l.current = e
    }, [C.current, x]), n.useEffect(() => {
        var e;
        return (e = navigator.mediaDevices) == null || e.getUserMedia({
            audio: !0
        }).then(t => {
            m.current = t
        }), () => {
            l.current && l.current.destroy(), m.current && m.current.getTracks().forEach(t => t.stop()), oe || o("Camera", {
                action: "close"
            })
        }
    }, []), te("camera:usedCommand", e => {
        switch (e) {
            case "toggleTaking":
                k();
                break;
            case "toggleFlip":
                X(t => !t);
                break;
            case "toggleFlash":
                G(t => !t);
                break;
            case "leftMode":
                if (d) return;
                E(t => {
                    const a = g.indexOf(t);
                    return a === 0 ? g[g.length - 1] : g[a - 1]
                });
                break;
            case "rightMode":
                if (d) return;
                E(t => {
                    const a = g.indexOf(t);
                    return a === g.length - 1 ? g[0] : g[a + 1]
                });
                break
        }
    }), n.useEffect(() => {
        if (!U.current) return;
        let e = [];
        const a = setInterval(() => {
            e.length > 2 && (e = []), e.push("."), U.current.innerText = ne("APPS.CAMERA.UPLOADING") + e.join("")
        }, 500);
        return () => clearInterval(a)
    }, [$]);
    const L = (e, t) => {
        if (t === void 0 && (t = Pe(e)), t) {
            const a = document.createElement("video");
            a.src = e, a.muted = !0, a.play();
            const r = document.createElement("canvas");
            if (!r) return;
            a.addEventListener("loadeddata", () => {
                r.width = a.videoWidth, r.height = a.videoHeight, r.getContext("2d").drawImage(a, 0, 0, r.width, r.height);
                const v = r.toDataURL("image/png");
                D.current.style.backgroundImage = `url(${v})`, V.APPS.CAMERA.lastImage.set(v), r.remove(), a.remove()
            })
        } else D.current.style.backgroundImage = `url(${e})`, V.APPS.CAMERA.lastImage.set(e)
    };
    n.useEffect(() => {
        if (o("Camera", {
                action: x ? "open" : "close"
            }), ie || !N) o("toggleFlashlight", {
            toggled: !1
        }), I(0), E("Photo");
        else {
            if (o("Camera", {
                    action: "flipCamera",
                    value: A
                }), V.APPS.CAMERA.lastImage.value) return L(V.APPS.CAMERA.lastImage.value);
            o("Camera", {
                action: "getLastImage"
            }).then(e => {
                e && L(e)
            })
        }
    }, [N, H, x]), n.useEffect(() => {
        if (d) return;
        switch (c) {
            case "Landscape":
                B({
                    marginRight: "9rem"
                }), I(90);
                break;
            case "Video":
                I(0), B({
                    marginLeft: "12rem"
                });
                break;
            default:
                I(0), B({
                    marginLeft: "3rem"
                });
                break
        }
        c === "Landscape" ? l.current && l.current.resizeByAspect(16 / 9) : (c === "Video" || c === "Photo") && l.current && l.current.resizeByAspect(3 / 4), o("Camera", {
            action: "toggleLandscape",
            toggled: c === "Landscape"
        }), o("Camera", {
            action: "toggleVideo",
            toggled: c === "Video"
        });
        const e = window.innerWidth;
        e > 1920 && l.current.setQuality(1920 / e), c === "Photo" && A ? l.current.setXOffset(-.2) : l.current.setXOffset(0)
    }, [c]), n.useEffect(() => {
        o("Camera", {
            action: "flipCamera",
            value: A
        }), !d && (c == "Photo" && A ? l.current.setXOffset(-.2) : l.current.setXOffset(0))
    }, [N, A]);
    const Q = n.useRef(!0),
        q = async (e, t) => {
            const a = re(e.size / 1e3, 2);
            return new Promise((r, v) => {
                Ie(t ? "Video" : "Image", e).then(R => {
                    t ? L(URL.createObjectURL(e), !0) : L(R), u("info", `Saved ${t?"video":"photo"} to gallery (${a}kb) - ${R}`), Ae(R, a).then(r), M && o("toggleFlashlight", {
                        toggled: !1
                    }), r(!0)
                }).catch(v)
            })
        };
    te("camera:toggleMicrophone", e => {
        m.current && (m.current.getAudioTracks()[0].enabled = e)
    }), n.useEffect(() => {
        if (Q.current) {
            Q.current = !1;
            return
        }
        if (M && !d && o("toggleFlashlight", {
                toggled: !1
            }), !d) return;
        const e = C.current.captureStream(f.videoOptions.fps),
            t = new AudioContext,
            a = new MediaStreamAudioDestinationNode(t);
        if (m.current ? (o("isTalking").then(y => {
                m.current.getAudioTracks()[0].enabled = y
            }), t.createMediaStreamSource(m.current).connect(a)) : t.createOscillator().connect(a), f.recordNearbyVoices) {
            var r = f.ice ? new ae({
                config: {
                    iceTransportPolicy: "relay",
                    iceServers: f.ice
                }
            }) : new ae;
            r.on("open", h => {
                o("Camera", {
                    action: "setRecordingPeerId",
                    peerId: h
                }), u("info", "Listening for nearby voices")
            });
            const i = document.createElement("canvas");
            i.width = 1, i.height = 1;
            const y = i.captureStream(0);
            r.on("call", h => {
                h.answer(y), h.on("stream", w => {
                    u("info", "Received nearby voice");
                    const z = new Audio;
                    z.srcObject = w, z.volume = 0, z.play(), new MediaStreamAudioSourceNode(t, {
                        mediaStream: w
                    }).connect(a)
                }), h.on("close", () => {
                    u("info", "Stopped receiving nearby voice")
                })
            })
        }
        const v = [e.getVideoTracks()[0]];
        (m.current || f.recordNearbyVoices) && v.unshift(a.stream.getAudioTracks()[0]);
        const R = new MediaStream(v),
            p = new MediaRecorder(R, {
                mimeType: "video/webm;codecs=vp9,opus",
                videoBitsPerSecond: f.videoOptions.bitrate * 8 * 1e3
            });
        let Y = Date.now();
        const me = p.audioBitsPerSecond + p.videoBitsPerSecond,
            Z = setInterval(() => {
                const i = (Date.now() - Y) / 1e3,
                    h = me * i / 8 / 1024 / 1024,
                    w = re(h, 2);
                w >= f.videoOptions.size && (u("info", `Video file size limit reached (${w}mb)`), clearInterval(Z), k())
            }, 100);
        let _ = [];
        p.ondataavailable = i => {
            _.push(i.data)
        }, p.onerror = i => {
            u("error", "error recording:", i)
        }, p.onstop = () => {
            clearInterval(Z);
            let i = Date.now() - Y,
                y = new Blob(_, {
                    type: "video/webm"
                });
            pe(y, i, {
                logger: !1
            }).then(h => {
                b(!0), t.close(), r && (r.destroy(), u("info", "Destroyed peer connection"), o("Camera", {
                    action: "endedRecording"
                })), q(h, !0).then(() => {
                    b(!1)
                }).catch(() => {
                    b(!1), T(!0), setTimeout(() => {
                        T(!1)
                    }, 1e4)
                })
            })
        }, p.start();
        const ge = setInterval(() => {
            if (J >= f.videoOptions.duration) return k();
            K(i => i + 1 >= f.videoOptions.duration ? (k(), 0) : i + 1)
        }, 1e3);
        return () => {
            K(0), clearInterval(ge), p.stop()
        }
    }, [d]);
    const fe = e => {
            let t = (e % 60).toString(),
                a = (Math.floor(e / 60) % 60).toString(),
                r = Math.floor(e / 3600).toString();
            return parseInt(r) < 10 && (r = "0" + r), parseInt(a) < 10 && (a = "0" + a), parseInt(t) < 10 && (t = "0" + t), r + ":" + a + ":" + t
        },
        k = () => {
            if ($) return u("info", "Returning since an image is currently uploading");
            if (M && o("toggleFlashlight", {
                    toggled: !0
                }), c == "Video") {
                o("Camera", {
                    action: "toggleHud",
                    toggled: d
                }).then(() => {
                    de(e => !e)
                });
                return
            }
            o("Camera", {
                action: "toggleHud",
                toggled: !1
            }), setTimeout(() => {
                var e, t;
                (t = (e = j.Settings.value) == null ? void 0 : e.sound) != null && t.silent || j.SoundManager.set({
                    url: "./assets/sound/other/cameraShutter.mp3"
                }), W(!0), F.IndicatorVisible.set(!1), setTimeout(() => {
                    W(!1), o("Camera", {
                        action: "toggleHud",
                        toggled: !0
                    })
                }, 200), C.current.toBlob(a => {
                    b(!0), u("info", "Uploading image, converting to blob"), q(a, !1).then(() => {
                        u("info", "Image uploaded successfully"), b(!1), F.IndicatorVisible.set(!0)
                    }).catch(r => {
                        b(!1), F.IndicatorVisible.set(!0), T(!0), setTimeout(() => {
                            T(!1)
                        }, 1e4)
                    })
                })
            }, 100)
        };
    return s(ee, {
        children: S("div", {
            className: "camera-container",
            children: [S("div", {
                className: "camera-header",
                children: [s("div", {
                    className: "flash",
                    onClick: () => G(e => !e),
                    children: !d && M ? s(Se, {}) : s(be, {})
                }), c === "Video" && S(ee, {
                    children: [s("div", {
                        className: "timer",
                        children: fe(J)
                    }), s("span", {})]
                })]
            }), S("div", {
                className: `camera-body ${c=="Landscape"?"rotate":""}`,
                children: [s("canvas", {
                    ref: C,
                    style: {
                        visibility: ce ? "hidden" : "visible"
                    }
                }), $ && S("div", {
                    className: "loading",
                    children: [s(Ce, {
                        size: 80,
                        speed: 1,
                        color: "#ffffff"
                    }), s("div", {
                        className: "uploading",
                        ref: U,
                        children: "Uploading..."
                    })]
                }), le && s("div", {
                    className: "loading",
                    children: s("div", {
                        className: "uploading",
                        children: "Failed to upload, tell the server owner to check their API keys in lb-phone/server/apiKeys.lua"
                    })
                })]
            }), S("div", {
                className: "camera-bottom",
                children: [s("div", {
                    className: "camera-types",
                    style: ue,
                    children: g.map((e, t) => s("div", {
                        className: `${c===e&&"active"}`,
                        onClick: () => E(e),
                        children: ne(`APPS.CAMERA.${e.toUpperCase()}`)
                    }, t))
                }), S("div", {
                    className: "camera-buttons",
                    children: [s("div", {
                        className: "image-gallery",
                        ref: D,
                        onClick: () => {
                            !H && !N || (o("Camera", {
                                action: "close"
                            }), I(0), j.App.set({
                                name: "Photos"
                            }))
                        }
                    }), s("div", {
                        className: "camera-button",
                        onClick: () => k(),
                        children: s("div", {
                            className: "camera-button-container",
                            children: s("div", {
                                className: `camera-button-inner ${c=="Video"&&`${c} ${d==!0&&"Recording"}`}`
                            })
                        })
                    }), s("div", {
                        className: "flip-camera",
                        onClick: () => {
                            X(e => !e)
                        },
                        children: s(ye, {})
                    })]
                })]
            })]
        })
    })
}
export {
    Te as
    default
};