import {
    r as n,
    a as l,
    j as i,
    F as O
} from "./jsx-runtime-f40812bf.js";
import {
    b as H,
    f as P,
    J as v,
    L as e,
    b9 as A,
    bi as u,
    ab as h,
    C as d,
    be as S,
    ao as C,
    bj as M,
    bk as p,
    S as f
} from "./Phone-8f8bff8f.js";
import "./number-28525126.js";
const T = n.createContext(null);

function U() {
    const [r, t] = n.useState([]), o = H(f.Unlocked), [c, a] = n.useState(null), [m, E] = n.useState(1);
    return n.useEffect(() => {
        E(Math.floor(Math.random() * 5) + 1)
    }, [o]), n.useEffect(() => {
        P("Home", {
            action: "getHomes"
        }).then(s => {
            s && t(s)
        })
    }, []), l("div", {
        className: "home-container",
        style: {
            backgroundImage: `url(./assets/img/backgrounds/default/apps/home/${m}.png)`
        },
        children: [i(v.div, {
            animate: {
                backdropFilter: "blur(10px) brightness(0.75)"
            },
            exit: {
                backdropFilter: "inherit"
            },
            transition: {
                duration: 1
            },
            className: "blur-overlay"
        }), i("div", {
            className: "home-header",
            children: c ? l(O, {
                children: [i("div", {
                    className: "title",
                    children: e("APPS.HOME.MY_HOME")
                }), i(A, {
                    className: "close",
                    onClick: () => a(null)
                })]
            }) : i(O, {
                children: l("div", {
                    className: "title",
                    children: [i(u, {}), " ", e("APPS.HOME.MY_HOMES")]
                })
            })
        }), i("div", {
            className: "home-wrapper",
            children: c ? i(_, {
                data: c
            }) : i("div", {
                className: "items",
                children: r.map((s, N) => l("div", {
                    className: "item small",
                    onClick: () => a(s),
                    children: [i("div", {
                        className: "icon blue",
                        children: i(u, {})
                    }), l("div", {
                        className: "info",
                        children: [i("div", {
                            className: "title",
                            children: s.label
                        }), s.id && l("div", {
                            className: "value",
                            children: ["#", s.id]
                        })]
                    })]
                }, N))
            })
        })]
    })
}
const _ = ({
    data: r
}) => {
    const [t, o] = n.useState(r), c = n.useRef(null);
    return l(O, {
        children: [l("div", {
            className: "title",
            children: [e("APPS.HOME.ACTIONS"), i(h, {})]
        }), l("div", {
            className: "category",
            children: [l("div", {
                className: "item",
                onClick: () => {
                    d.PopUp.set({
                        title: e("APPS.HOME.WAYPOINT_POPUP.TITLE"),
                        description: e("APPS.HOME.WAYPOINT_POPUP.TEXT").format({
                            home: t.label
                        }),
                        buttons: [{
                            title: e("APPS.HOME.WAYPOINT_POPUP.CANCEL")
                        }, {
                            title: e("APPS.HOME.WAYPOINT_POPUP.PROCEED"),
                            cb: () => {
                                P("Home", {
                                    action: "setWaypoint",
                                    id: t.id
                                })
                            }
                        }]
                    })
                },
                children: [i("div", {
                    className: "icon blue",
                    children: i(S, {})
                }), l("div", {
                    className: "info",
                    children: [i("div", {
                        className: "title",
                        children: e("APPS.HOME.LOCATION")
                    }), i("div", {
                        className: "value",
                        children: e("APPS.HOME.SET_WAYPOINT")
                    })]
                })]
            }), t.locked !== void 0 && l("div", {
                className: `item ${t.locked?"active":""}`,
                onClick: () => {
                    d.PopUp.set({
                        title: e("APPS.HOME.LOCK_POPUP.TITLE").format({
                            toggle: t.locked ? e("APPS.HOME.UNLOCK") : e("APPS.HOME.LOCK")
                        }),
                        description: e("APPS.HOME.LOCK_POPUP.TEXT").format({
                            toggle: (t.locked ? e("APPS.HOME.UNLOCK") : e("APPS.HOME.LOCK")).toLowerCase()
                        }),
                        buttons: [{
                            title: e("APPS.HOME.LOCK_POPUP.CANCEL")
                        }, {
                            title: e("APPS.HOME.LOCK_POPUP.PROCEED"),
                            cb: () => {
                                P("Home", {
                                    action: "toggleLocked",
                                    id: t.id,
                                    uniqueId: t.uniqueId
                                }).then(a => {
                                    a !== void 0 && o({
                                        ...t,
                                        locked: a
                                    })
                                })
                            }
                        }]
                    })
                },
                children: [i("div", {
                    className: "icon blue",
                    children: i(C, {})
                }), l("div", {
                    className: "info",
                    children: [i("div", {
                        className: "title",
                        children: e("APPS.HOME.FRONT_DOOR")
                    }), i("div", {
                        className: "value",
                        children: t.locked ? e("APPS.HOME.LOCKED") : e("APPS.HOME.UNLOCKED")
                    })]
                })]
            }), l("div", {
                className: "item",
                onClick: () => {
                    d.PopUp.set({
                        title: e("APPS.HOME.GIVE_KEY_POPUP.TITLE"),
                        description: e("APPS.HOME.GIVE_KEY_POPUP.TEXT"),
                        input: {
                            placeholder: "0",
                            type: "text",
                            minCharacters: 1,
                            onChange: a => c.current = a
                        },
                        buttons: [{
                            title: e("APPS.HOME.GIVE_KEY_POPUP.CANCEL")
                        }, {
                            title: e("APPS.HOME.GIVE_KEY_POPUP.PROCEED"),
                            cb: () => {
                                c && P("Home", {
                                    action: "addKeyholder",
                                    id: t.id,
                                    source: c.current
                                }).then(a => {
                                    a && (c.current = null, o({
                                        ...t,
                                        keyholders: a
                                    }))
                                })
                            }
                        }]
                    })
                },
                children: [i("div", {
                    className: "icon yellow",
                    children: i(M, {})
                }), l("div", {
                    className: "info",
                    children: [i("div", {
                        className: "title",
                        children: e("APPS.HOME.GIVE_KEY")
                    }), i("div", {
                        className: "value",
                        children: e("APPS.HOME.MANAGE")
                    })]
                })]
            })]
        }), l("div", {
            className: "title",
            children: [e("APPS.HOME.KEY_ACCESS"), i(h, {})]
        }), i("div", {
            className: "category scroll",
            children: t == null ? void 0 : t.keyholders.map((a, m) => l("div", {
                className: "item small full",
                onClick: () => {
                    d.PopUp.set({
                        title: e("APPS.HOME.REMOVE_KEY_POPUP.TITLE"),
                        description: e("APPS.HOME.REMOVE_KEY_POPUP.TEXT").format({
                            name: a.name
                        }),
                        buttons: [{
                            title: e("APPS.HOME.REMOVE_KEY_POPUP.CANCEL")
                        }, {
                            title: e("APPS.HOME.REMOVE_KEY_POPUP.PROCEED"),
                            cb: () => {
                                P("Home", {
                                    action: "removeKeyholder",
                                    id: t.id,
                                    identifier: a.identifier
                                }).then(E => {
                                    E && o({
                                        ...t,
                                        keyholders: t.keyholders.filter(s => s !== a)
                                    })
                                })
                            }
                        }]
                    })
                },
                children: [i("div", {
                    className: "icon blue",
                    children: i(p, {})
                }), l("div", {
                    className: "info",
                    children: [i("div", {
                        className: "title",
                        children: a.name
                    }), i("div", {
                        className: "value",
                        children: e("APPS.HOME.MANAGE")
                    })]
                })]
            }, m))
        })]
    })
};
export {
    T as HomeContext, U as
    default
};