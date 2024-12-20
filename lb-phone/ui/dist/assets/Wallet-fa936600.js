import {
    r,
    a as s,
    j as a,
    F as A
} from "./jsx-runtime-f40812bf.js";
import {
    b as P,
    f as L,
    u as k,
    H as U,
    J as x,
    a5 as R,
    L as n,
    C as w,
    k as W,
    n as b,
    aK as B,
    a4 as G,
    c as M,
    h as y
} from "./Phone-8f8bff8f.js";
import {
    r as v,
    f as T
} from "./number-28525126.js";
import {
    N as H
} from "./Numpad-cc7ba39c.js";

function J() {
    const N = P(M.Settings),
        c = P(y),
        [l, f] = r.useState({
            balance: 0,
            transactions: [],
            bills: []
        }),
        [o, d] = r.useState(!1),
        [g, F] = r.useState(""),
        [i, S] = r.useState(0),
        [C, p] = r.useState(!1),
        [t, m] = r.useState(""),
        [h, u] = r.useState(null);
    r.useEffect(() => {
        L("Wallet", {
            action: "getData"
        }).then(e => {
            e && f(e)
        })
    }, []), r.useEffect(() => {
        m(""), S(0)
    }, [o]), k("wallet:addTransaction", e => {
        N.airplaneMode || f({
            ...l,
            balance: l.balance + e.amount,
            transactions: [e, ...l.transactions].slice(0, 5)
        })
    }), r.useEffect(() => {
        i === 0 ? t.length > 0 ? p(!0) : p(!1) : i === 1 && (t.length > 0 && _(parseFloat(t)) && parseFloat(t) <= (c.MaxTransferAmount ?? Number.MAX_SAFE_INTEGER) ? p(!0) : p(!1))
    }, [t]);
    const _ = e => l.balance >= e,
        D = e => {
            if (e == "backspace") return m(E => E.length > 0 ? E.slice(0, -1) : "0");
            m(E => E + e)
        };
    return r.useEffect(() => {
        if (i !== 1 || t.length >= 9) return;
        const e = document.getElementById("number");
        e.style.width = `${t.length}ch`, h && u(null)
    }, [t]), r.useEffect(() => {
        u(null)
    }, [i]), s("div", {
        className: "wallet-app-container",
        children: [a(U, {
            children: o && s(x.div, {
                ...R,
                className: "send-container",
                children: [s("div", {
                    className: "send-header",
                    children: [a("div", {
                        onClick: () => d(!1),
                        children: n("CANCEL")
                    }), i === 2 ? a("div", {
                        onClick: () => d(!1),
                        children: n("APPS.WALLET.DONE")
                    }) : a("div", {
                        className: !C && "disabled",
                        onClick: () => {
                            if (C) {
                                if (i == 0) L("Wallet", {
                                    action: "doesNumberExist",
                                    number: t
                                }).then(e => {
                                    e ? (F(t), S(1), m("")) : u(n("APPS.WALLET.NUMBER_DOES_NOT_EXIST"))
                                });
                                else if (i == 1) {
                                    if (!_(parseFloat(t))) return u(n("APPS.WALLET.NOT_ENOUGH_MONEY"));
                                    if (parseFloat(t) > (c.MaxTransferAmount ?? Number.MAX_SAFE_INTEGER)) return u("Max transfer amount reached");
                                    if (N.airplaneMode) {
                                        w.PopUp.set({
                                            title: n("MISC.AIRPLANE_MODE_POPUP.TITLE"),
                                            description: n("MISC.AIRPLANE_MODE_POPUP.DESCRIPTION"),
                                            buttons: [{
                                                title: n("MISC.AIRPLANE_MODE_POPUP.OK")
                                            }]
                                        });
                                        return
                                    }
                                    L("Wallet", {
                                        action: "sendPayment",
                                        number: g,
                                        amount: Math.floor(parseFloat(t))
                                    }).then(e => {
                                        e != null && e.success ? S(2) : u(n("APPS.WALLET.NOT_ENOUGH_MONEY"))
                                    })
                                }
                            }
                        },
                        children: n("APPS.WALLET.NEXT")
                    })]
                }), s("div", {
                    className: "send-wrapper",
                    children: [i === 0 && s(A, {
                        children: [a("div", {
                            className: "user",
                            children: a(W, {
                                className: "number_input",
                                type: "number",
                                onChange: e => m(e.target.value.replace(/[^0-9]/g, "")),
                                value: t,
                                placeholder: b("Perm ID")
                            })
                        }), a("div", {
                            className: "description",
                            children: n("APPS.WALLET.NO_REFUNDS")
                        }), h && a("div", {
                            className: "error",
                            children: h
                        })]
                    }), i === 1 && s(A, {
                        children: [s("div", {
                            className: "amount",
                            children: [a("div", {
                                className: "symbol",
                                children: c.CurrencyFormat.replace("%s", "")
                            }), a(W, {
                                type: "number",
                                id: "number",
                                value: t,
                                onChange: e => m(e.target.value.replace(/[^0-9]/g, ""))
                            })]
                        }), s("div", {
                            className: "description",
                            children: ["Sending to ID: "+g+" ", n("APPS.WALLET.NEW_BALANCE"), ": ", c.CurrencyFormat.replace("%s", ""), T(isNaN(v(l.balance - parseFloat(t), 2)) ? l.balance : v(l.balance - parseFloat(t), 2))]
                        }), h && a("div", {
                            className: "error",
                            children: h
                        })]
                    }), i === 2 && s("div", {
                        className: "success",
                        children: [a(B, {}), a("div", {
                            className: "title",
                            children: n("APPS.WALLET.DONE")
                        }), a("div", {
                            className: "subtitle",
                            children: n("APPS.WALLET.DONE_SUBTITLE").format({
                                amount: c.CurrencyFormat.replace("%s", t),
                                number: b(g)
                            })
                        })]
                    })]
                }), i !== 2 && a("div", {
                    className: "numpad-wrapper",
                    children: a(H, {
                        cb: e => D(e)
                    })
                })]
            })
        }), s("div", {
            className: "overview",
            children: [a("div", {
                className: "header-title",
                children: n("APPS.WALLET.TITLE")
            }), s("div", {
                className: "wrapper",
                children: [a("div", {
                    className: "card"
                }), a("section", {
                    children: s("div", {
                        className: "item space",
                        children: [s("div", {
                            className: "balance",
                            children: [a("div", {
                                className: "title",
                                children: n("APPS.WALLET.BALANCE")
                            }), a(X, {
                                amount: l.balance
                            })]
                        }), a("div", {
                            className: "button",
                            onClick: () => d(!0),
                            children: n("APPS.WALLET.SEND")
                        })]
                    })
                }), l.transactions && l.transactions.length > 0 && s(A, {
                    children: [a("div", {
                        className: "subtitle",
                        children: a("div", {
                            className: "title",
                            children: n("APPS.WALLET.LATEST_TRANSACTIONS")
                        })
                    }), a("section", {
                        children: l.transactions.map((e, E) => {
                            let I = e.amount > 0,
                                O = e.company.match(/\d{10}/);
                            return s("div", {
                                className: "item multi",
                                children: [e.logo ? a("img", {
                                    src: e.logo
                                }) : !O && a("div", {
                                    className: "image",
                                    children: e.company[0]
                                }), s("div", {
                                    className: "info",
                                    children: [s("div", {
                                        className: "transaction-header",
                                        children: [a("div", {
                                            className: "title",
                                            children: O ? b(e.company) : e.company
                                        }), a("div", {
                                            className: "right",
                                            children: s("div", {
                                                className: `amount ${I?"green":"red"}`,
                                                children: [!I && "-", c.CurrencyFormat.replace("%s", T(Math.abs(e.amount)))]
                                            })
                                        })]
                                    }), a("div", {
                                        className: "date",
                                        children: G(e.timestamp)
                                    })]
                                })]
                            })
                        })
                    })]
                }), l.bills && l.bills.length > 0 && s(A, {
                    children: [a("div", {
                        className: "subtitle",
                        children: a("div", {
                            className: "title",
                            children: n("APPS.WALLET.LATEST_BILLS")
                        })
                    }), a("section", {})]
                })]
            })]
        })]
    })
}
const X = ({
    amount: N
}) => {
    const c = P(y),
        [l, f] = r.useState(!0),
        o = P(M.Settings);
    let d;
    return l && (o != null && o.streamerMode) ? d = T(parseInt("⁎".repeat(v(N, 2).toString().length))) : d = T(v(N, 2)), a("div", {
        className: "value",
        onClick: () => f(!l),
        children: c.CurrencyFormat.replace("%s", d)
    })
};
export {
    J as
    default
};