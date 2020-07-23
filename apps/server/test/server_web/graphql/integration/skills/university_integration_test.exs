defmodule ServerWeb.GraphQL.Integration.Skills.UniversityIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns universities - `AbsintheHelpers`" do
    end

    it "returns universities - `Absinthe.run`" do
    end
  end

  describe "#show" do
    it "returns specific university by id - `AbsintheHelpers`" do
    end

    it "returns specific university by id - `Absinthe.run`" do
    end

    it "returns not found when university does not exist - `AbsintheHelpers`" do
    end

    it "returns not found when university does not exist - `Absinthe.run`" do
    end

    it "returns error for missing params - `AbsintheHelpers`" do
    end

    it "returns error for missing params - `Absinthe.run`" do
    end
  end

  describe "#create" do
    it "creates university - `AbsintheHelpers`" do
    end

    it "creates university - `Absinthe.run`" do
    end

    it "returns error for missing params - `AbsintheHelpers`" do
    end

    it "returns error for missing params - `Absinthe.run`" do
    end
  end

  describe "#delete" do
    it "delete specific university by id - `AbsintheHelpers`" do
    end

    it "delete specific university by id - `Absinthe.run`" do
    end

    it "returns not found when university does not exist - `AbsintheHelpers`" do
    end

    it "returns not found when university does not exist - `Absinthe.run`" do
    end

    it "returns error for missing params - `AbsintheHelpers`" do
    end

    it "returns error for missing params - `Absinthe.run`" do
    end
  end
end
