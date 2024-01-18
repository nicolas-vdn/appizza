export interface JSONRegister {
    name: string,
    email: string,
    password: string
}

export interface JSONAuthType {
    name: string,
    email: string,
    password: string,
    salt: string,
    authToken?: string
}