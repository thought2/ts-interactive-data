import { assert } from "chai";
import { extract, toEitherV } from "../ts-src";
import {
  DataUICtx,
  Error as DataUIError,
} from "../output/InteractiveData.Core.Types";
import { pipe } from "fp-glue";
import { Either } from "../output/Data.Either";

describe("Array", () => {
  describe("#indexOf()", () => {
    it("should return -1 when the value is not present", () => {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });

  describe("record", () => {
    describe("extract", () => {
      it("should return -1 when the value is not present", () => {
        assert.equal([1, 2, 3].indexOf(4), -1);

        const ctx = 1 as unknown as DataUICtx;

        const result: Either<DataUIError, {}> = pipe({}, extract({}, ctx));
        const resultV = toEitherV(result);

        assert.equal(resultV.type, "right");
        assert.equal(resultV.value , "right");


      });
    });
  });
});
