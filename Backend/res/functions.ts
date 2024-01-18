import { JSONRegister } from "./interfaces";

export function validationChamps(champs: JSONRegister) {
    const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g;
    return  (champs.name && champs.name.length < 64) &&
            (champs.email && champs.email.length < 64 && champs.email.match(emailRegex)) &&
            (champs.password && champs.password.length < 64);
}

export function formatData(champs: JSONRegister) {
    champs.name = champs.name.replace(/[^\w -]/g, '');
    champs.password = champs.password.replace(/ /g, '');
    champs.email = champs.email.replace(/ /g, '');

    return champs;
}