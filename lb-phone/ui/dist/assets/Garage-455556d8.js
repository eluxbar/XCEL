import {
    r as h,
    a as i,
    j as e,
    F as m
} from "./jsx-runtime-f40812bf.js";
import {
    f as N,
    d as E,
    L as l,
    C as u,
    e as R,
    E as S,
    h as b
} from "./Phone-1ddf01c8.js";
import {
    m as O,
    a$ as g,
    aS as p,
    an as r,
    b0 as C,
    F as f,
    b1 as I,
    b2 as T,
    b3 as U,
    u as L,
    b4 as k,
    S as _,
    b5 as V,
    b6 as D,
    aY as y,
    b7 as F,
    b8 as M,
    aN as K,
    aZ as Y,
    ag as j
} from "./index.esm-e1f47206.js";
import "./number-28525126.js";

function $() {
    const [n, t] = h.useState(null), [c, a] = h.useState([]);
    h.useEffect(() => {
        N("Garage", {
            action: "getVehicles"
        }).then(s => {
            if (!s) return E("info", "No response from getVehicles");
            a(s)
        })
    }, []);
    const o = {
        car: e(p, {}),
        boat: e(C, {}),
        plane: e(f, {}),
        bike: e(I, {}),
        truck: e(T, {}),
        train: e(U, {})
    };
    return i("div", {
        className: "garage-container",
        style: {
            backgroundImage: "url(./assets/img/backgrounds/default/apps/garage/2.jpg)"
        },
        children: [e(O.div, {
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
            children: n ? i(m, {
                children: [e("div", {
                    className: "title",
                    children: n.model
                }), e(g, {
                    className: "close",
                    onClick: () => t(null)
                })]
            }) : i("div", {
                className: "title",
                children: [e(p, {}), " ", l("APPS.GARAGE.MY_CARS")]
            })
        }), e("div", {
            className: "garage-wrapper",
            children: n ? e(w, {
                Vehicle: [n, t],
                Vehicles: [c, a]
            }) : i(m, {
                children: [c.filter(s => s.location === "out" && !s.impounded).length > 0 && i(m, {
                    children: [i("div", {
                        className: "subtitle",
                        children: [l("APPS.GARAGE.OUT"), e(r, {})]
                    }), e("section", {
                        children: c.filter(s => s.location === "out" && !s.impounded).map((s, d) => i("div", {
                            className: "item small",
                            onClick: () => t(s),
                            children: [e("div", {
                                className: "icon blue",
                                children: o[s.type]
                            }), i("div", {
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
                }), c.filter(s => s.location !== "out" && !s.impounded).length > 0 && i(m, {
                    children: [i("div", {
                        className: "subtitle",
                        children: [l("APPS.GARAGE.GARAGE"), e(r, {})]
                    }), e("section", {
                        children: c.filter(s => s.location !== "out" && !s.impounded).map((s, d) => i("div", {
                            className: "item small",
                            onClick: () => t(s),
                            children: [e("div", {
                                className: "icon blue",
                                children: o[s.type]
                            }), i("div", {
                                className: "info",
                                children: [e("div", {
                                    className: "title",
                                    children: s.model
                                }), i("div", {
                                    className: "value",
                                    children: [s.plate, " - ", s.location]
                                })]
                            })]
                        }, d))
                    })]
                }), c.filter(s => s.impounded).length > 0 && i(m, {
                    children: [i("div", {
                        className: "subtitle",
                        children: [l("APPS.GARAGE.IMPOUNDED"), e(r, {})]
                    }), e("section", {
                        children: c.filter(s => s.impounded).map((s, d) => i("div", {
                            className: "item small",
                            onClick: () => t(s),
                            children: [e("div", {
                                className: "icon blue",
                                children: o[s.type]
                            }), i("div", {
                                className: "info",
                                children: [e("div", {
                                    className: "title",
                                    children: s.model
                                }), i("div", {
                                    className: "value",
                                    children: [s.plate, " - ", s.location]
                                })]
                            })]
                        }, d))
                    })]
                })]
            })
        })]
    })
}
const w = ({
    Vehicle: n,
    Vehicles: t
}) => {
    var v;
    const c = L(b),
        [a, o] = n,
        [s, d] = t;
    return i("div", {
        className: "options-container",
        children: [i("div", {
            className: "grid-wrapper",
            children: [i("div", {
                className: "subtitle",
                children: [l("APPS.GARAGE.ACTIONS"), e(r, {})]
            }), i("div", {
                className: "grid",
                children: [i("div", {
                    className: "item big",
                    onClick: () => {
                        u.PopUp.set({
                            title: l("APPS.GARAGE.WAYPOINT_POPUP.TITLE"),
                            description: l("APPS.GARAGE.WAYPOINT_POPUP.TEXT").format({
                                model: a.model
                            }),
                            buttons: [{
                                title: l("APPS.GARAGE.WAYPOINT_POPUP.CANCEL")
                            }, {
                                title: l("APPS.GARAGE.WAYPOINT_POPUP.PROCEED"),
                                cb: () => {
                                    N("Garage", {
                                        action: "setWaypoint",
                                        plate: a.plate
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(k, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.LOCATION")
                        }), e("div", {
                            className: "value",
                            children: R(a.location === "out" ? l("APPS.GARAGE.OUT") : a.location)
                        })]
                    })]
                }), a.locked !== void 0 && i("div", {
                    className: "item big",
                    "data-active": a.locked,
                    onClick: () => {
                        u.PopUp.set({
                            title: l("APPS.GARAGE.LOCK_POPUP.TITLE").format({
                                toggle: a.locked ? l("APPS.GARAGE.UNLOCK") : l("APPS.GARAGE.LOCK")
                            }),
                            description: l("APPS.GARAGE.LOCK_POPUP.TEXT").format({
                                toggle: (a.locked ? l("APPS.GARAGE.UNLOCK") : l("APPS.GARAGE.LOCK")).toLowerCase()
                            }),
                            buttons: [{
                                title: l("APPS.GARAGE.LOCK_POPUP.CANCEL")
                            }, {
                                title: l("APPS.GARAGE.LOCK_POPUP.PROCEED"),
                                cb: () => {
                                    N("Garage", {
                                        action: "toggleLocked",
                                        plate: a.plate
                                    }).then(G => {
                                        G !== void 0 && (d(A => A.map(P => P.plate === a.plate ? {
                                            ...P,
                                            locked: !P.locked
                                        } : P)), o(A => ({
                                            ...A,
                                            locked: !A.locked
                                        })))
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(_, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.STATUS")
                        }), e("div", {
                            className: "value",
                            children: a.locked ? l("APPS.GARAGE.LOCKED") : l("APPS.GARAGE.UNLOCKED")
                        })]
                    })]
                }), c.valet.enabled && i("div", {
                    className: "item big",
                    onClick: () => {
                        u.PopUp.set({
                            title: l("APPS.GARAGE.VALET_POPUP.TITLE"),
                            description: c.valet.price && c.valet.price > 0 ? l("APPS.GARAGE.VALET_POPUP.TEXT_PAID").format({
                                model: a.model,
                                plate: a.plate,
                                amount: c.valet.price
                            }) : l("APPS.GARAGE.VALET_POPUP.TEXT").format({
                                model: a.model,
                                plate: a.plate
                            }),
                            buttons: [{
                                title: l("APPS.GARAGE.VALET_POPUP.CANCEL")
                            }, {
                                title: l("APPS.GARAGE.VALET_POPUP.PROCEED"),
                                cb: () => {
                                    N("Garage", {
                                        action: "valet",
                                        plate: a.plate
                                    })
                                }
                            }]
                        })
                    },
                    children: [e("div", {
                        className: "icon blue",
                        children: e(V, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.SUMMON")
                        }), e("div", {
                            className: "value",
                            children: l("APPS.GARAGE.VALET")
                        })]
                    })]
                })]
            })]
        }), a.statistics && Object.keys(a.statistics).length > 0 && i("div", {
            className: "grid-wrapper",
            children: [i("div", {
                className: "subtitle",
                children: [l("APPS.GARAGE.STATISTICS"), e(r, {})]
            }), i("div", {
                className: "grid",
                children: [a.statistics.fuel && i("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(D, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.FUEL")
                        }), i("div", {
                            className: "value",
                            children: [a.statistics.fuel, "%"]
                        })]
                    })]
                }), a.statistics.engine && i("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(y, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.ENGINE")
                        }), i("div", {
                            className: "value",
                            children: [a.statistics.engine, "%"]
                        })]
                    })]
                }), a.statistics.body && i("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(F, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.BODY")
                        }), i("div", {
                            className: "value",
                            children: [a.statistics.body, "%"]
                        })]
                    })]
                })]
            })]
        }), a.impounded && a.impoundReason && Object.keys(a.impoundReason).length > 0 && i("div", {
            className: "grid-wrapper",
            children: [i("div", {
                className: "subtitle",
                children: [l("APPS.GARAGE.IMPOUND_INFO"), e(r, {})]
            }), i("div", {
                className: "grid",
                children: [a.impoundReason.reason && i("div", {
                    className: "item big",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(M, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.IMPOUND_REASON.REASON")
                        }), e("div", {
                            className: "value",
                            children: a.impoundReason.reason
                        })]
                    })]
                }), a.impoundReason.impounder && i("div", {
                    className: "item big",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(K, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.IMPOUND_REASON.IMPOUNDER")
                        }), e("div", {
                            className: "value",
                            children: a.impoundReason.impounder
                        })]
                    })]
                }), a.impoundReason.price !== void 0 && i("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(Y, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.IMPOUND_REASON.PRICE")
                        }), e("div", {
                            className: "value",
                            children: (v = c == null ? void 0 : c.CurrencyFormat) == null ? void 0 : v.replace("%s", a.impoundReason.price.toString())
                        })]
                    })]
                }), a.impoundReason.retrievable && i("div", {
                    className: "item small",
                    children: [e("div", {
                        className: "icon blue",
                        children: e(j, {})
                    }), i("div", {
                        className: "info",
                        children: [e("div", {
                            className: "title",
                            children: l("APPS.GARAGE.IMPOUND_REASON.RETRIEVABLE")
                        }), e("div", {
                            className: "value",
                            children: S(a.impoundReason.retrievable)
                        })]
                    })]
                })]
            })]
        })]
    })
};
export {
    $ as
    default
};