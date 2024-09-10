import {
    r as G,
    a,
    j as e,
    F as P
} from "./jsx-runtime-f40812bf.js";
import {
    f as m,
    J as E,
    b9 as p,
    a_ as v,
    L as i,
    ab as h,
    ba as b,
    ar as g,
    bb as S,
    bc as C,
    bd as O,
    b as R,
    C as N,
    be as f,
    g as T,
    ao as I,
    bf as L,
    bg as k,
    b4 as U,
    bh as V,
    h as _
} from "./Phone-8f8bff8f.js";
import "./number-28525126.js";

function x() {
    const [c, n] = G.useState(null), [t, l] = G.useState([]);
    G.useEffect(() => {
        m("Garage", {
            action: "getVehicles"
        }).then(s => {
            s && l(s)
        })
    }, []);
    const r = {
        car: e(v, {}),
        boat: e(b, {}),
        plane: e(g, {}),
        bike: e(S, {}),
        truck: e(C, {}),
        train: e(O, {})
    };
    return a("div", {
        className: "garage-container",
        style: {
            backgroundImage: "url(./assets/img/backgrounds/default/apps/garage/2.jpg)"
        },
        children: [e(E.div, {
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
        }), e("div", {
            className: "garage-header",
            children: c ? a(P, {
                children: [e("div", {
                    className: "title",
                    children: c.model
                }), e(p, {
                    className: "close",
                    onClick: () => n(null)
                })]
            }) : a("div", {
                className: "title",
                children: [e(v, {}), " ", i("APPS.GARAGE.MY_CARS")]
            })
        }), e("div", {
            className: "garage-wrapper",
            children: c ? e(y, {
                Vehicle: [c, n],
                Vehicles: [t, l]
            }) : a(P, {
                children: [t.filter(s => s.location === "out").length > 0 && a(P, {
                    children: [a("div", {
                        className: "subtitle",
                        children: [i("APPS.GARAGE.OUT"), e(h, {})]
                    }), e("section", {
                        children: t.filter(s => s.location === "out").map((s, d) => a("div", {
                            className: "item small",
                            onClick: () => n(s),
                            children: [e("div", {
                                className: "icon blue",
                                children: r[s.type]
                            }), a("div", {
                                className: "info",
                                children: [e("div", {
                                    className: "title",
                                    children: s.model
                                }), e("div", {
                                    className: "value",
                                    children: s.plate
                                })]
                            })]
                        }, d))
                    })]
                }), t.filter(s => s.location !== "out").length > 0 && a(P, {
                    children: [a("div", {
                        className: "subtitle",
                        children: [i("APPS.GARAGE.GARAGE"), e(h, {})]
                    }), e("section", {
                        children: t.filter(s => s.location !== "out").map((s, d) => a("div", {
                            className: "item small",
                            onClick: () => n(s),
                            children: [e("div", {
                                className: "icon blue",
                                children: r[s.type]
                            }), a("div", {
                                className: "info",
                                children: [e("div", {
                                    className: "title",
                                    children: s.model
                                }), a("div", {
                                    className: "value",
                                    children: [s.spawncode]
                                })]
                            })]
                        }, d))
                    })]
                })]
            })
        })]
    })
}
const y = ({
    Vehicle: c,
    Vehicles: n
}) => {
    const t = R(_),
        [l, r] = c,
        [s, d] = n;
    return a("div", {
        className: "options-container",
        children: [a("div", {
            className: "grid-wrapper",
            children: [a("div", {
                className: "subtitle",
                children: [i("APPS.GARAGE.ACTIONS"), e(h, {})]
            }), a("div", {
                className: "grid",
                children: [a("div", {
                    className: "item big",
                    onClick: () => {
                        N.PopUp.set({
                            title: i("APPS.GARAGE.WAYPOINT_POPUP.TITLE"),
                            description: i("APPS.GARAGE.WAYPOINT_POPUP.TEXT").format({
                                model: l.model
                            }),
                            buttons: [{
                                title: i("APPS.GARAGE.WAYPOINT_POPUP.CANCEL")
                            }, {
                                title: i("APPS.GARAGE.WAYPOINT_POPUP.PROCEED"),
                                cb: () => {
                                    m("Garage", {
                                        action: "setWaypoint",
                                        plate: l.plate
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(f, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.LOCATION")
                        }), e("div", {
                            className: "value",
                            children: T(l.location === "out" ? i("APPS.GARAGE.OUT") : l.location)
                        })]
                    })]
                }), l.locked !== void 0 && a("div", {
                    className: "item big",
                    "data-active": l.locked,
                    onClick: () => {
                        N.PopUp.set({
                            title: i("APPS.GARAGE.LOCK_POPUP.TITLE").format({
                                toggle: l.locked ? i("APPS.GARAGE.UNLOCK") : i("APPS.GARAGE.LOCK")
                            }),
                            description: i("APPS.GARAGE.LOCK_POPUP.TEXT").format({
                                toggle: (l.locked ? i("APPS.GARAGE.UNLOCK") : i("APPS.GARAGE.LOCK")).toLowerCase()
                            }),
                            buttons: [{
                                title: i("APPS.GARAGE.LOCK_POPUP.CANCEL")
                            }, {
                                title: i("APPS.GARAGE.LOCK_POPUP.PROCEED"),
                                cb: () => {
                                    m("Garage", {
                                        action: "toggleLocked",
                                        plate: l.plate
                                    }).then(u => {
                                        u !== void 0 && (d(o => o.map(A => A.plate === l.plate ? {
                                            ...A,
                                            locked: !A.locked
                                        } : A)), r(o => ({
                                            ...o,
                                            locked: !o.locked
                                        })))
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(I, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.STATUS")
                        }), e("div", {
                            className: "value",
                            children: l.locked ? i("APPS.GARAGE.LOCKED") : i("APPS.GARAGE.UNLOCKED")
                        })]
                    })]
                }), t.valet.enabled && l.location !== "out" && l.type === "car" && a("div", {
                    className: "item big",
                    onClick: () => {
                        N.PopUp.set({
                            title: i("APPS.GARAGE.VALET_POPUP.TITLE"),
                            description: t.valet.price && t.valet.price > 0 ? i("APPS.GARAGE.VALET_POPUP.TEXT_PAID").format({
                                model: l.model,
                                plate: l.plate,
                                amount: t.valet.price
                            }) : i("APPS.GARAGE.VALET_POPUP.TEXT").format({
                                model: l.model,
                                plate: l.plate
                            }),
                            buttons: [{
                                title: i("APPS.GARAGE.VALET_POPUP.CANCEL")
                            }, {
                                title: i("APPS.GARAGE.VALET_POPUP.PROCEED"),
                                cb: () => {
                                    m("Garage", {
                                        action: "valet",
                                        plate: l.plate,
                                        spawncode: l.spawncode,
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(L, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.SUMMON")
                        }), e("div", {
                            className: "value",
                            children: i("APPS.GARAGE.VALET")
                        })]
                    })]
                })]
            })]
        }), l.statistics && Object.keys(l.statistics).length > 0 && a("div", {
            className: "grid-wrapper",
            children: [a("div", {
                className: "subtitle",
                children: [i("APPS.GARAGE.STATISTICS"), e(h, {})]
            }), a("div", {
                className: "grid",
                children: [l.statistics.fuel && a("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(k, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.FUEL")
                        }), a("div", {
                            className: "value",
                            children: [l.statistics.fuel, "%"]
                        })]
                    })]
                }), l.statistics.engine && a("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(U, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.ENGINE")
                        }), a("div", {
                            className: "value",
                            children: [l.statistics.engine, "%"]
                        })]
                    })]
                }), l.statistics.body && a("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(V, {})
                    }), a("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: i("APPS.GARAGE.BODY")
                        }), a("div", {
                            className: "value",
                            children: [l.statistics.body, "%"]
                        })]
                    })]
                })]
            })]
        })]
    })
};
export {
    x as
    default
};